const AWS = require('aws-sdk');
const nodemailer = require('nodemailer');

// Configuração do S3
const s3 = new AWS.S3();
const BUCKET_NAME = process.env.S3_BUCKET_NAME; // Nome do bucket do S3

// Configuração do Nodemailer
const userEmail = process.env.EMAIL_USER;
const passEmail = process.env.EMAIL_PASS;

const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 587,
  secure: false,
  auth: {
    user: userEmail,
    pass: passEmail,
  },
});

// Função para buscar o template do S3
const getTemplateFromS3 = async (templateFile) => {

  console.log('Recuperando templates de email do bucket s3');

  try {
    const params = {
      Bucket: BUCKET_NAME,
      Key: `templates/${templateFile}`, // Diretório dentro do bucket
    };

    const data = await s3.getObject(params).promise();
    console.log('Template recuperado com sucesso!');
    return data.Body.toString('utf-8'); // Retorna o conteúdo do HTML
  } catch (error) {
    console.log(`Erro ao buscar template ${templateFile} do S3:`, error);
    return null;
  }
};

exports.handler = async (event) => {
  console.log('Iniciando Lambda');
  console.log('Event:', event);

  for (const record of event.Records) {
    let body;
    try {
      body = JSON.parse(record.body);
    } catch (error) {
      console.log('Corpo da mensagem inválido:', record.body);
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'Corpo da requisição inválido' }),
      };
    }

    const { toEmail, subject, message, template } = body;
    if (!toEmail || !subject || !message) {
        console.log('Parâmetros obrigatórios ausentes:', body);
        return {
          statusCode: 400,
          body: JSON.stringify({ message: `Parâmetros obrigatórios ausentes: ${body}`}),
        };
    }

    let mailOptions = {
      from: userEmail,
      to: toEmail,
      subject: subject,
    };

    if (template) {
      const templateFile = process.env[template.toUpperCase()]; // Busca o nome do arquivo na variável de ambiente
      if (templateFile) {
        const htmlContent = await getTemplateFromS3(templateFile);
        if (htmlContent) {
          mailOptions.html = htmlContent.replace('{{message}}', message);
        } else {
          console.log(`Template ${template} não encontrado no S3.`);
          mailOptions.text = message;
        }
      } else {
        console.log(`Template ${template} não definido nas variáveis de ambiente.`);
        mailOptions.text = message;
      }
    } else {
      mailOptions.text = message;
    }

    try {
      await transporter.sendMail(mailOptions);
      console.log(`E-mail enviado para ${toEmail}`);
      return {
        statusCode: 200,
        body: JSON.stringify({ message: `E-mail enviado para ${toEmail}` }),
      };
    } catch (error) {
      console.log(`Erro ao enviar e-mail para ${toEmail}:`, error);
      return {
        statusCode: 400,
        body: JSON.stringify({ message: `Erro ao enviar e-mail para ${toEmail}:`}),
      };
    }
  }
};
