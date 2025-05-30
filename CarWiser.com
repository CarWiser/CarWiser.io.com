<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Elite Car Finder</title>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Montserrat', sans-serif;
      background-color: #0d0d0d;
      color: white;
      padding: 40px 20px;
      min-height: 100vh;
    }

    h1 {
      text-align: center;
      font-size: 3rem;
      color: #FFD700;
      margin-bottom: 40px;
    }

    .brand-buttons {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 10px;
      margin-bottom: 40px;
    }

    .brand-buttons button {
      padding: 10px 20px;
      background: linear-gradient(45deg, #FFD700, #ffae00);
      border: none;
      border-radius: 8px;
      color: black;
      font-weight: bold;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .brand-buttons button:hover {
      transform: scale(1.05);
      box-shadow: 0 0 15px #FFD700;
    }

    .modal {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0, 0, 0, 0.8);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }

    .modal-content {
      background: #1a1a1a;
      padding: 30px;
      border-radius: 15px;
      text-align: center;
      color: white;
      max-width: 600px;
      width: 90%;
    }

    .close {
      float: right;
      font-size: 24px;
      cursor: pointer;
      color: #FFD700;
    }

    .brand-history, .model-details {
      margin-top: 20px;
      font-size: 0.95rem;
      color: #ccc;
      text-align: left;
    }

    .brand-image {
      margin-top: 20px;
      max-width: 100%;
      border-radius: 10px;
    }

    footer {
      margin-top: 60px;
      text-align: center;
      color: #888;
      font-size: 0.8rem;
    }
  </style>
</head>
<body>
  <h1>Elite Car Brand Explorer</h1>

  <div class="brand-buttons">
    <button onclick="showBrand('Lamborghini')">Lamborghini</button>
    <button onclick="showBrand('Ferrari')">Ferrari</button>
    <button onclick="showBrand('BMW')">BMW</button>
    <button onclick="showBrand('Mercedes-Benz')">Mercedes-Benz</button>
    <button onclick="showBrand('Audi')">Audi</button>
    <button onclick="showBrand('Porsche')">Porsche</button>
    <button onclick="showBrand('Maruti')">Maruti</button>
    <button onclick="showBrand('Tata')">Tata</button>
    <button onclick="showBrand('Hyundai')">Hyundai</button>
    <button onclick="showBrand('Kia')">Kia</button>
  </div>

  <div class="modal" id="brandModal">
    <div class="modal-content">
      <span class="close" onclick="closeBrandModal()">&times;</span>
      <h2 id="brandName"></h2>
      <img id="brandImage" class="brand-image" src="" alt="Car image">
      <p id="brandModels"></p>
      <div class="model-details" id="modelDetails"></div>
      <div class="brand-history" id="brandHistory"></div>
    </div>
  </div>

  <footer>
    &copy; 2025 Elite Car Finder. All rights reserved. Images and trademarks belong to their respective owners.
  </footer>

  <script>
    const brandData = {
      "Lamborghini": {
        models: ["350 GT (1964)", "Miura", "Countach", "Diablo", "Murciélago", "Gallardo", "Huracán", "Aventador", "Revuelto"],
        history: "Founded in 1963 by Ferruccio Lamborghini to compete with Ferrari, Lamborghini is known for its extravagant, high-performance sports cars featuring sharp styling and powerful V12 engines.",
        image: "https://upload.wikimedia.org/wikipedia/commons/6/6e/Lamborghini_Aventador_LP700-4.jpg",
        modelDetails: "The Aventador is a flagship supercar with a 6.5L V12 engine. The Huracán is a V10-powered beast ideal for daily thrills. Earlier models like Miura and Countach set design trends for decades."
      },
      "Ferrari": {
        models: ["125 S (1947)", "250 GTO", "F40", "Enzo", "458 Italia", "488", "SF90 Stradale", "812 Superfast"],
        history: "Ferrari, established by Enzo Ferrari in 1939, represents Italian excellence in performance and design, dominating both road and track with style.",
        image: "https://upload.wikimedia.org/wikipedia/commons/c/cd/Ferrari_812_Superfast_IMG_1802.jpg",
        modelDetails: "The 250 GTO is one of the most valuable classics. The F40 celebrated Ferrari's 40th anniversary. The SF90 Stradale is Ferrari's first plug-in hybrid supercar."
      },
      "BMW": {
        models: ["3 Series", "5 Series", "7 Series", "X5", "M3", "i8", "iX"],
        history: "BMW, or Bayerische Motoren Werke, started in 1916 as an aircraft engine manufacturer. Today, it's known for delivering the ultimate driving experience.",
        image: "https://upload.wikimedia.org/wikipedia/commons/2/21/BMW_M3_Competition_%28G80%29_IMG_5367.jpg",
        modelDetails: "The M3 is a performance icon. The i8 was BMW’s hybrid sportscar vision. The iX represents its futuristic EV lineup."
      },
      "Mercedes-Benz": {
        models: ["190E", "C-Class", "E-Class", "S-Class", "GLE", "G-Class", "AMG GT"],
        history: "Mercedes-Benz has been innovating since Karl Benz's first automobile in 1886. It's a global icon of luxury, safety, and engineering.",
        image: "https://upload.wikimedia.org/wikipedia/commons/b/b1/2018_Mercedes-Benz_S_560_L.jpg",
        modelDetails: "The S-Class sets luxury benchmarks. The G-Class is a rugged yet luxurious SUV. AMG GT showcases Mercedes’ performance engineering."
      },
      "Audi": {
        models: ["Quattro", "A4", "A6", "Q7", "R8", "e-tron"],
        history: "Audi's legacy began in 1909 and rose with its quattro all-wheel-drive tech. The brand stands for luxury with progressive engineering.",
        image: "https://upload.wikimedia.org/wikipedia/commons/f/f3/Audi_R8_Coupe_Gen_2_Facelift_IMG_4145.jpg",
        modelDetails: "The R8 is Audi’s V10 supercar. The Quattro rally car brought AWD to the masses. The e-tron series leads Audi’s electric revolution."
      },
      "Porsche": {
        models: ["356", "911", "Boxster", "Cayenne", "Macan", "Taycan"],
        history: "Founded in 1931 by Ferdinand Porsche, the company became legendary with the 911. Porsche balances racing heritage with everyday usability.",
        image: "https://upload.wikimedia.org/wikipedia/commons/6/60/Porsche_911_Carrera_4S_%28992%29_IMG_4602.jpg",
        modelDetails: "The 911 is Porsche’s timeless icon. The Taycan is its electric future. The Cayenne started the high-performance SUV trend."
      },
      "Maruti": {
        models: ["800 (1983)", "Alto", "Swift", "WagonR", "Baleno", "Ertiga"],
        history: "Maruti Suzuki revolutionized Indian motoring starting in 1983. It's India's largest carmaker, known for affordable and reliable cars.",
        image: "https://upload.wikimedia.org/wikipedia/commons/0/04/Maruti_Swift_2021.jpg",
        modelDetails: "The 800 was India’s first mass-market car. Swift is a sporty hatchback. Baleno caters to premium hatchback buyers."
      },
      "Tata": {
        models: ["Indica", "Nano", "Tiago", "Tigor", "Nexon", "Harrier", "Safari"],
        history: "Part of the Tata Group, Tata Motors was founded in 1945. It's known for indigenous vehicles, innovation, and electric mobility in India.",
        image: "https://upload.wikimedia.org/wikipedia/commons/2/27/2020_Tata_Harrier_XZA%2B.jpg",
        modelDetails: "The Indica was Tata’s first passenger car. Nexon is its EV flagship. Harrier and Safari lead the SUV lineup."
      },
      "Hyundai": {
        models: ["Santro", "i10", "i20", "Verna", "Creta", "Tucson"],
        history: "Hyundai entered India in the late 90s and quickly became a popular choice for stylish, feature-rich and reliable cars.",
        image: "https://upload.wikimedia.org/wikipedia/commons/d/d7/Hyundai_Creta_2020.jpg",
        modelDetails: "Santro was India’s first compact tallboy. The Creta dominates mid-size SUV sales. Tucson is Hyundai’s global flagship SUV."
      },
      "Kia": {
        models: ["Seltos", "Sonet", "Carnival", "EV6"],
        history: "Kia, a Hyundai affiliate, launched in India in 2019. It impressed the market with modern designs, tech-savvy interiors, and safety.",
        image: "https://upload.wikimedia.org/wikipedia/commons/5/5e/Kia_Seltos_2020.jpg",
        modelDetails: "Seltos and Sonet became instant hits. EV6 showcases Kia’s electric ambitions. Carnival is a luxury MPV."
      }
    };

    function showBrand(brand) {
      document.getElementById("brandName").innerText = brand;
      document.getElementById("brandImage").src = brandData[brand].image;
      document.getElementById("brandModels").innerText = "Popular Models: " + brandData[brand].models.join(", ");
      document.getElementById("brandHistory").innerText = brandData[brand].history;
      document.getElementById("modelDetails").innerText = brandData[brand].modelDetails;
      document.getElementById("brandModal").style.display = "flex";
    }

    function closeBrandModal() {
      document.getElementById("brandModal").style.display = "none";
    }
  </script>
</body>
</html>

