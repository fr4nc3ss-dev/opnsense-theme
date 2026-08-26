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

# 3. Alterar textos de OPNsense para FW-Cyberappfin
echo "[3/5] Alterando nome da interface para $NOVO_NOME..."
find /usr/local/opnsense/www/themes/$NOME_TEMA -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.json" \) -exec sed -i '' "s/OPNsense/$NOVO_NOME/g" {} +
find /usr/local/opnsense/www/themes/$NOME_TEMA -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.json" \) -exec sed -i '' "s/opnsense/$NOVO_NOME/g" {} +

# 4. Substituição Global de Hexadecimais Laranjas por Cinza
echo "[4/5] Removendo todas as tonalidades de laranja..."
THEME_DIR="/usr/local/opnsense/www/themes/$NOME_TEMA"

# Varredura ampla de tons de laranja conhecidos do OPNsense
ORANGES="#EA7105 #D95100 #B85904 #E05D06 #E67E22 #F39C12 #F05A28 #F26522 #FF7A00 #FA6B03 #D9534F"
for color in $ORANGES; do
    find $THEME_DIR -type f \( -name "*.css" -o -name "*.js" \) -exec sed -i '' "s/$color/#444444/gI" {} +
done

# Injeta regras específicas para neutralizar linhas inferiores de títulos (::after e hr)
CSS_DIR="$THEME_DIR/build/css"
for f in $CSS_DIR/*.css; do
cat << 'EOF' >> "$f"

/* ==========================================
   ELIMINAÇÃO DE LINHAS DE TÍTULO (CYBERAPPFIN)
   ========================================== */

/* Linhas e bordas de títulos de widgets/painéis */
.panel-heading,
.widget-header,
.widget-title,
.panel-title,
div[class*="panel"] h3,
div[class*="panel"] h4,
div[class*="widget"] h3,
div[class*="widget"] h4,
.content-box h3,
header h3,
header h4 {
    border-bottom-color: #444444 !important;
}

/* Pseudo-elementos (linhas desenhadas via CSS abaixo do texto) */
.panel-heading::after,
.panel-heading::before,
.widget-header::after,
.widget-header::before,
.widget-title::after,
.widget-title::before,
.panel-title::after,
.panel-title::before,
h3::after, h3::before,
h4::after, h4::before,
header::after, header::before,
hr {
    background-color: #444444 !important;
    border-color: #444444 !important;
}

/* Linhas e bordas dos quadros/cards */
.panel, 
.panel-default, 
.panel-primary, 
div[class*="panel"], 
div[class*="widget"], 
.content-box {
    border-color: #444444 !important;
}

/* Menu lateral e seleções */
.sidebar-nav li a.active,
.sidebar-nav li.active > a,
.navigation-menu .active > a {
    border-left: 4px solid #333333 !important;
    background-color: #e5e5e5 !important;
    color: #000000 !important;
}

/* Botões e Ações */
.btn-primary, 
button[type="submit"] {
    background-color: #333333 !important;
    border-color: #222222 !important;
    color: #ffffff !important;
}

.btn-primary:hover,
button[type="submit"]:hover {
    background-color: #444444 !important;
    border-color: #333333 !important;
}

/* Paginação e Abas */
.pagination > .active > a, 
.pagination > .active > span {
    background-color: #333333 !important;
    border-color: #222222 !important;
}

.nav-tabs > li.active > a {
    border-top: 3px solid #444444 !important;
    color: #000000 !important;
}

/* Cores de texto padrão */
a, .text-primary, .text-danger, .text-warning, .text-info {
    color: #333333 !important;
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
