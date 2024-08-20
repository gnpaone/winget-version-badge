import express from "express";
import cors from "cors";
import * as dotenv from "dotenv";
const axios = require('axios');
const app = express();
const port = 3000;

app.use(cors());
dotenv.config();

interface Version {
  version: string;
  installerType: string;
  installers: string[];
}

interface DataItem {
  _id: string;
  versions: Version[];
}

interface JsonData {
  props: {
    pageProps: {
      data: DataItem[];
    };
  };
}

app.get("/", async (req, res) => {
  const { id, style, label, labelColor, color } = req.query;
  const badgeColor = color ? color : 'blue';
  const badgeLabel = label ? label as string : 'Winget package';

  if (!id) {
    return res.status(400).json({ error: 'Missing required id query parameter' });
  }

  try {
    const headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "text/html",
    };
    const response = await axios.get(`${process.env.API_URL}${(id as string).toLowerCase()}`, { headers });
    const htmlText = response.data;
    const jsdom = require("jsdom");
    const dom = new jsdom.JSDOM(htmlText);
    const jsonData: JsonData = JSON.parse(dom.window.document.getElementById(process.env.JSON_ID)!.textContent!);

    const versionData = jsonData.props.pageProps.data.find((item: DataItem) => item._id.toLowerCase() === (id as string).toLowerCase());
    if (!versionData) {
      return res.status(404).json({ error: "Package not found" });
    }

    const latestVersion = versionData.versions[versionData.versions.length - 1].version;

    const imgResponse = await axios.get(`https://img.shields.io/badge/${encodeURIComponent(badgeLabel)}-${latestVersion}-${badgeColor}?style=${style}&labelColor=${labelColor}`, {
      responseType: 'arraybuffer',
    });

    res.setHeader("Content-Type", "image/svg+xml");
    res.status(200).send(imgResponse.data);
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
