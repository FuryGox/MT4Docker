#!/bin/bash
ACCOUNT=$1
PASSWORD=$2
SERVER=$3

# 1. Tạo file cấu hình tự động login
cat <<EOF > /app/MT4Login.ini
; common settings
Login=$ACCOUNT
Password=$PASSWORD
Server=$SERVER
EnableNews=0
AutoConfiguration=true
;experts
ExpertsEnable=true
ExpertsDllImport=true
;charts
Symbol=XAUUSD
Period=H4
Expert=LumirMT4_v2
EOF

# 1. Dọn dẹp các file lock cũ nếu có (Tránh lỗi "Server is already active")
rm -f /tmp/.X99-lock
rm -rf /tmp/.X11-unix/X99

# 2. Khởi động Xvfb và kiểm tra xem nó đã chạy thực sự chưa
Xvfb :99 -screen 0 1280x1024x24 &
sleep 2

# Kiểm tra nếu Xvfb không chạy được thì thoát sớm để debug
if ! pgrep -x "Xvfb" > /dev/null; then
    echo "LỖI: Xvfb không khởi động được!"
    exit 1
fi

# 2. Cấu hình Wine để chạy ổn định hơn
export WINEPREFIX=/home/wine/.wine
export WINEARCH=win32
export WINEDEBUG=-all
export WINEDLLOVERRIDES="mscoree,mshtml=;secur32=n,b"
export DISPLAY=:99

# Tạo Wine prefix nếu chưa có
wineboot -u

cat <<EOF > /home/wine/.wine/user.reg
[HKEY_CURRENT_USER\Software\Wine\DllOverrides]
"mscoree"=""
"mshtml"=""
"secur32"="n,b"
EOF

echo "Cấu hình Wine đã sẵn sàng."

echo "Login MT4 với tài khoản: $ACCOUNT, Server: $SERVER"

echo "Đang khởi động MT4..."

# 3. Chạy MT4 
# Chuyển vào thư mục chứa terminal để tránh lỗi đường dẫn tương đối nội bộ của Wine
cd /app/mt4/

# QUAN TRỌNG: Phải có tiền tố /config: cho file cấu hình và Z: cho đường dẫn Linux
wine terminal.exe /portable /config:Z:/app/MT4Login.ini &

# Giữ container sống để xem log
echo "MT4 đang chạy ngầm..."
sleep infinity