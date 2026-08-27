// build.js — gera dist/main.lua a partir de src/
// Rode com: node build.js
// (Roblox loadstring(game:HttpGet(url)) só busca UM arquivo, então a lib
// inteira precisa virar um bundle único — é isso que esse script faz.)

const fs = require("fs");
const path = require("path");

const SRC = path.join(__dirname, "src");
const OUT = path.join(__dirname, "dist", "main.lua");

const ELEMENTS_DIR = path.join(SRC, "Elements");
const ELEMENT_ORDER = ["Button", "Toggle", "Dropdown", "Slider"]; // adicione novos elements aqui

function readSrc(file) {
  return fs.readFileSync(file, "utf8");
}

function build() {
  let libraryCore = readSrc(path.join(SRC, "Library.lua"));
  // remove o "return Library" final — só devolvemos a lib no fim do bundle
  libraryCore = libraryCore.replace(/\nreturn Library\s*$/, "\n");

  let cardHelper = readSrc(path.join(ELEMENTS_DIR, "Card.lua"));
  // remove o "return Card" final — a variável local `Card` continua no
  // escopo do bundle e é usada direto pelos elements abaixo
  cardHelper = cardHelper.replace(/\nreturn Card\s*$/, "\n");

  const elementChunks = ELEMENT_ORDER.map((name) => {
    const file = path.join(ELEMENTS_DIR, `${name}.lua`);
    let content = readSrc(file);

    // remove a linha de require (Card já está no escopo do bundle)
    // (usa .* pra pegar também o comentário que vem depois do require)
    content = content.replace(/^local Card = require\(script\.Parent\.Card\).*\n/m, "");

    // transforma "return function(parent, config) ... end" em um
    // Library:RegisterElement("Nome", function(parent, config) ... end)
    content = content.replace(
      /^return function\(parent, config\)/m,
      `Library:RegisterElement("${name}", function(parent, config)`
    );
    // fecha o parêntese extra do RegisterElement no fim do arquivo
    content = content.replace(/\nend\s*$/, "\nend)\n");

    return `-- === Elements/${name}.lua ===\n${content}`;
  });

  const bundle = `--[[
    NarsUILib — dist/main.lua (GERADO AUTOMATICAMENTE por build.js)
    NÃO EDITE ESSE ARQUIVO DIRETO — edite os arquivos em src/ e rode
    "node build.js" de novo.

    Uso:
        local Library = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPO/main/dist/main.lua"
        ))()
]]

-- === Library.lua ===
${libraryCore}
-- === Elements/Card.lua (helper, não é um Element registrado) ===
${cardHelper}
${elementChunks.join("\n")}
return Library
`;

  fs.mkdirSync(path.dirname(OUT), { recursive: true });
  fs.writeFileSync(OUT, bundle, "utf8");
  console.log("dist/main.lua gerado com sucesso (" + bundle.length + " bytes).");
}

build();
