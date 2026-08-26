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

# 4. Substituição Global de Hexadecimais para Tons de Cinza
echo "[4/5] Aplicando padrão 100% cinza e preto no CSS..."
THEME_DIR="/usr/local/opnsense/www/themes/$NOME_TEMA"

find $THEME_DIR -type f \( -name "*.css" -o -name "*.js" \) -exec sed -i '' 's/#EA7105/#444444/gI' {} +
find $THEME_DIR -type f \( -name "*.css" -o -name "*.js" \) -exec sed -i '' 's/#D95100/#222222/gI' {} +
find $THEME_DIR -type f \( -name "*.css" -o -name "*.js" \) -exec sed -i '' 's/#B85904/#333333/gI' {} +
find $THEME_DIR -type f \( -name "*.css" -o -name "*.js" \) -exec sed -i '' 's/#E05D06/#444444/gI' {} +
find $THEME_DIR -type f \( -name "*.css" -o -name "*.js" \) -exec sed -i '' 's/#E67E22/#555555/gI' {} +
find $THEME_DIR -type f \( -name "*.css" -o -name "*.js" \) -exec sed -i '' 's/#F39C12/#666666/gI' {} +

# Injeta CSS padronizado em Cinza
CSS_DIR="$THEME_DIR/build/css"
for f in $CSS_DIR/*.css; do
cat << 'EOF' >> "$f"

/* ==========================================
   PADRONIZAÇÃO TOTAL EM CINZA FW-CYBERAPPFIN
   ========================================== */

/* 1. BORDAS DOS DASHBOARDS E WIDGETS (CINZA ESCURO) */
.panel, 
.panel-default, 
.panel-primary, 
div[class*="panel"], 
div[class*="widget"], 
.content-box {
    border-color: #444444 !important;
}

.panel-heading, 
.widget-header, 
div[class*="panel"] > h3, 
div[class*="panel"] hr, 
.panel-title, 
hr {
    border-top: 2px solid #444444 !important;
    border-bottom-color: #444444 !important;
}

/* 2. MENU LATERAL E SELEÇÕES */
.sidebar-nav li a.active,
.sidebar-nav li.active > a,
.navigation-menu .active > a {
    border-left: 4px solid #333333 !important;
    background-color: #e5e5e5 !important;
    color: #000000 !important;
}

/* 3. BOTÕES PRIMÁRIOS E AÇÕES */
.btn-primary, 
.btn-primary:focus, 
.btn-primary:active, 
.btn-primary.active,
.open > .dropdown-toggle.btn-primary,
button[type="submit"] {
    background-color: #333333 !important;
    border-color: #222222 !important;
    color: #ffffff !important;
}

.btn-primary:hover,
button[type="submit"]:hover {
    background-color: #444444 !important;
    border-color: #333333 !important;
    color: #ffffff !important;
}

/* 4. PAGINAÇÃO E ABAS */
.pagination > .active > a, 
.pagination > .active > span {
    background-color: #333333 !important;
    border-color: #222222 !important;
    color: #ffffff !important;
}

.pagination > li > a, .pagination > li > span {
    color: #333333 !important;
}

.nav-tabs > li.active > a, 
.nav-tabs > li.active > a:hover, 
.nav-tabs > li.active > a:focus {
    border-top: 3px solid #444444 !important;
    color: #000000 !important;
}

/* 5. TEXTOS, LINKS E GRÁFICOS SVG */
a, .text-primary, .text-danger, .text-warning, .text-info {
    color: #333333 !important;
}

svg path[fill="#EA7105"], svg path[fill="#ea7105"],
svg path[fill="#D95100"], svg path[fill="#d95100"],
svg path[fill="#e67e22"], svg path[fill="#f39c12"] {
    fill: #555555 !important;
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
