#!/bin/sh

# ==========================================
# CONFIGURAÇÕES DO TEMA
# ==========================================
NOME_TEMA="cyberappfin"
NOVO_NOME="FW-Cyberappfin"

USUARIO_GITHUB="fr4nc3ss-dev"
REPO_GITHUB="opnsense-theme"
BRANCH="main"

URL_BASE="https://raw.githubusercontent.com/${USUARIO_GITHUB}/${REPO_GITHUB}/${BRANCH}"

echo "=========================================="
echo "  Iniciando instalacao do tema $NOME_TEMA"
echo "=========================================="

# 1. Criar diretorio do tema
echo "[1/5] Criando estrutura do tema..."
rm -rf /usr/local/opnsense/www/themes/$NOME_TEMA
cp -r /usr/local/opnsense/www/themes/opnsense /usr/local/opnsense/www/themes/$NOME_TEMA

# 2. Baixar as imagens do GitHub
echo "[2/5] Baixando imagens do GitHub..."
cd /usr/local/opnsense/www/themes/$NOME_TEMA/build/images/
rm -f default-logo.* icon-logo.*

fetch -o default-logo.png "${URL_BASE}/logo.png"
fetch -o icon-logo.png "${URL_BASE}/icon.png"

# 3. Alterar textos no tema (OPNsense -> FW-Cyberappfin)
echo "[3/5] Alterando nome da interface para $NOVO_NOME..."
find /usr/local/opnsense/www/themes/$NOME_TEMA -type f \( -name "*.html" -o -name "*.css" -o -name "*.json" \) -exec sed -i '' "s/OPNsense/$NOVO_NOME/g" {} +
find /usr/local/opnsense/www/themes/$NOME_TEMA -type f \( -name "*.html" -o -name "*.css" -o -name "*.json" \) -exec sed -i '' "s/opnsense/$NOVO_NOME/g" {} +

# 4. Alterar a cor Laranja para PRETO nos arquivos CSS
echo "[4/5] Modificando a cor dos botoes (Laranja -> Preto)..."
CSS_DIR="/usr/local/opnsense/www/themes/$NOME_TEMA/build/css"

sed -i '' 's/EA7105/1a1a1a/gI' $CSS_DIR/*.css
sed -i '' 's/ea7105/1a1a1a/gI' $CSS_DIR/*.css
sed -i '' 's/D95100/111111/gI' $CSS_DIR/*.css
sed -i '' 's/d95100/111111/gI' $CSS_DIR/*.css
sed -i '' 's/b85904/333333/gI' $CSS_DIR/*.css
sed -i '' 's/9c3a00/000000/gI' $CSS_DIR/*.css
sed -i '' 's/ED9A50/444444/gI' $CSS_DIR/*.css
sed -i '' 's/fedcbd/555555/gI' $CSS_DIR/*.css

# 5. Ajustar permissões
echo "[5/5] Ajustando permissoes do sistema..."
chown -R root:wheel /usr/local/opnsense/www/themes/$NOME_TEMA
chmod -R 755 /usr/local/opnsense/www/themes/$NOME_TEMA

echo "=========================================="
echo "  INSTALACAO CONCLUIDA COM SUCESSO!"
echo "=========================================="
