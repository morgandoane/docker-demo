import express from 'express';

const app = express();
const port = process.env.PORT ?? 8080;

app.get('/', (_req, res) => {
	res.send('Hello, TypeScript + Express deployed with Docker & Cloud Run!');
});

app.listen(port, () => {
	console.log(`Server listening on http://localhost:${port}`);
});
