const express = require("express");
const cors = require("cors");
const multer = require("multer");
const axios = require("axios");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

const upload = multer({ dest: "uploads/" });

app.post("/api/image-prompt-to-video", upload.single("image"), async (req, res) => {
  try {
    const { prompt, ratio } = req.body;
    const imagePath = req.file.path;

    // 🔥 REAL AI VIDEO API CALL (PSEUDO – replace endpoint)
    /*
    const aiResponse = await axios.post(
      "https://api.real-ai-video.com/generate",
      {
        image: fs.createReadStream(imagePath),
        prompt: prompt,
        duration: 30,
        ratio: ratio
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.VIDEO_API_KEY}`
        }
      }
    );
    const videoUrl = aiResponse.data.video_url;
    */

    // DEMO VIDEO (for testing)
    const videoUrl =
      ratio === "9:16"
        ? "https://sample-videos.com/video321/mp4/720/sample-vertical.mp4"
        : "https://sample-videos.com/video321/mp4/720/sample-horizontal.mp4";

    res.json({
      success: true,
      video_url: videoUrl,
      duration: 30
    });
  } catch (err) {
    res.status(500).json({ success: false, error: "Video generation failed" });
  }
});

app.listen(process.env.PORT, () => {
  console.log("Vidiofy backend running on port " + process.env.PORT);
});
