# docker-demo

A minimal TypeScript‑based Express server, Dockerized and ready for deployment on Google Cloud Run.

## Prerequisites

- [Node.js](https://nodejs.org/) v14+ (or use the included Dockerfile)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [Google Cloud SDK](https://cloud.google.com/sdk) installed and authenticated
- A Google Cloud project with Cloud Run API enabled

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/morgandoane/docker-demo.git
   cd docker-demo
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

## package.json Overview

```json
{
	"name": "docker-demo",
	"version": "1.0.0",
	"main": "index.js",
	"scripts": {
		"dev": "nodemon",
		"build": "tsc",
		"start": "node dist/index.js"
	},
	"author": "Morgan Doane",
	"license": "ISC",
	"dependencies": {
		"express": "^5.1.0"
	},
	"devDependencies": {
		"@types/express": "^5.0.2",
		"@types/node": "^22.15.19",
		"nodemon": "^3.1.10",
		"ts-node": "^10.9.2",
		"typescript": "^5.8.3"
	}
}
```

## tsconfig.json

```json
{
	"compilerOptions": {
		"target": "ES2020",
		"module": "commonjs",
		"lib": ["ES2020"],
		"outDir": "./dist",
		"rootDir": "./src",
		"strict": true,
		"esModuleInterop": true,
		"forceConsistentCasingInFileNames": true,
		"skipLibCheck": true,
		"resolveJsonModule": true,
		"allowSyntheticDefaultImports": true,
		"sourceMap": true
	},
	"include": ["src/**/*"],
	"exclude": ["node_modules", "dist"]
}
```

## Available Scripts

- **Start in development mode** (with live reload):

  ```bash
  npm run dev
  ```

  Uses `nodemon` to watch `src/` and restart on changes.

- **Build for production**:

  ```bash
  npm run build
  ```

  Compiles TypeScript from `src/` to `dist/`.

- **Run compiled code**:

  ```bash
  npm start
  ```

  Runs `node dist/index.js` on port `8080` by default.

## Code Sample

```ts
// src/index.ts
import express from 'express';

const app = express();
const port = process.env.PORT ?? 8080;

app.get('/', (_req, res) => {
	res.send('Hello, TypeScript + Express deployed with Docker & Cloud Run!');
});

app.listen(port, () => {
	console.log(`Server listening on http://localhost:${port}`);
});
```

## Docker

The included `Dockerfile` builds and packages the app:

1. Build the Docker image:

   ```bash
   docker build -t docker-demo .
   ```

2. Run locally:

   ```bash
   docker run -p 8080:8080 docker-demo
   ```

## Deploy to Google Cloud Run

Follow these steps to deploy your application using the current Google Cloud Run UI:

1. In the Google Cloud Console, navigate to **Cloud Run** and click **Create Service**.

2. Select **Continuously deploy from a repository (source or function)**:

   - Click on the GitHub option and authorize access if prompted
   - Select your `docker-demo` repository and the branch you wish to deploy (e.g., `main`)

3. Under **Configure**:
   - Enter a unique **Service name** (cannot be changed later)
   - Select your preferred **Region** (e.g., `europe-west1`)
   - Note the **Endpoint URL** that will be generated for your service
4. For **Authentication**, select **Allow unauthenticated invocations** as our application will handle authentication on its own.

5. You can set environment variables directly in the UI under the **Container, Variables & Secrets, Connections, Security** section:

   - Click to expand this section
   - Add environment variables as key-value pairs (e.g., `PORT=8080`)
   - You can add as many variables as needed for your application configuration

6. Click **Create** to deploy your service.

Cloud Build will automatically build and deploy your container based on the Dockerfile in your repository. On every new commit to the selected branch, Cloud Build and Cloud Run will rebuild and redeploy your service.

You can monitor builds and deployments under **Cloud Build** and view service logs, traffic patterns, and environment variables in the **Cloud Run** console.

## Environment Variables

- `PORT` (optional): Port for the server (default: `8080` in Cloud Run)

You can set environment variables in two ways:

1. Through the Cloud Run UI:

   - Navigate to your service in the Cloud Run console
   - Select the "Edit & Deploy New Revision" option
   - Expand the "Container, Variables & Secrets, Connections, Security" section
   - Add or modify environment variables as needed

2. Via gcloud CLI:
   ```bash
   gcloud run services update docker-demo --update-env-vars KEY=VALUE
   ```

## License

ISC © Morgan Doane
