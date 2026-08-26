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

# 4. Modificar cores e Injetar Regras CSS
echo "[4/5] Aplicando botoes em Cinza Escuro e linhas em Preto..."
CSS_DIR="/usr/local/opnsense/www/themes/$NOME_TEMA/build/css"

# Injeta a sobrescrita de estilos no final dos arquivos CSS
for f in $CSS_DIR/*.css; do
cat << 'EOF' >> "$f"

/* ==========================================
   CUSTOMIZACAO FW-CYBERAPPFIN
   ========================================== */

/* Botoes em Cinza Escuro */
.btn-primary, 
.btn-primary:focus, 
.btn-primary:active, 
.btn-primary.active,
button[type="submit"] {
    background-color: #333333 !important;
    border-color: #1a1a1a !important;
    color: #ffffff !important;
}

.btn-primary:hover,
button[type="submit"]:hover {
    background-color: #1a1a1a !important;
    border-color: #000000 !important;
    color: #ffffff !important;
}

/* Linhas superiores dos quadros/widgets em Preto */
.panel-primary > .panel-heading,
.panel-default > .panel-heading,
.panel-heading,
.widget-header,
h3, h4, hr {
    border-color: #000000 !important;
    border-top-color: #000000 !important;
}

div[class*="panel"], div[class*="widget"] {
    border-top-color: #000000 !important;
}

/* Textos e links destacados em Cinza Escuro */
a, .text-primary, .text-danger {
    color: #333333 !important;
}

a:hover, a:focus {
    color: #000000 !important;
}
EOF
done

# 5. Ajustar permissões
echo "[5/5] Ajustando permissoes do sistema..."
chown -R root:wheel /usr/local/opnsense/www/themes/$NOME_TEMA
chmod -R 755 /usr/local/opnsense/www/themes/$NOME_TEMA

echo "=========================================="
echo "  INSTALACAO CONCLUIDA COM SUCESSO!"
echo "=========================================="
