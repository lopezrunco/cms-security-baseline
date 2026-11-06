#!/bin/bash

# Usage: Type ./scan_sensitive_data.sh site.com.uy/public_html

# Check if the directory is valid.
if [ -z "$1" ]; then
    echo -e "\e[31m[!] Error: Please, write a valid path to the directory for scanning.\e[0m"
    echo -e "Usage: $0 /path/to/public_html"
    exit 1
fi

TARGET_DIR="$1"
REPORT_FILE="sensitive_data_report.txt"

# Validate that the directory actually exists.
if [ ! -dir "$TARGET_DIR" ]; then
    echo -e "\e[31m[!] Error: The directory '$TARGET_DIR' does not exist.\e[0m"
    exit 1
fi

# Initialize a clean report.
echo "==================================================" > "$REPORT_FILE"
echo "          AUTOMATED SECURITY REPORT: CODE         " >> "$REPORT_FILE"
echo "==================================================" >> "$REPORT_FILE"
echo "Scan date: $(date)" >> "$REPORT_FILE"
echo "Target: $TARGET_DIR" >> "$REPORT_FILE"
echo -e "==================================================\n" >> "$REPORT_FILE"

echo -e "\e[34m==================================================\e[0m"
echo -e "\e[34m     INITIALIZING ANTI-FALSE-POSITIVES SCAN       \e[0m"
echo -e "\e[34m==================================================\e[0m"
echo -e "[*] Analizing files in '$TARGET_DIR'..."

TOTAL_API=0
TOTAL_EMAILS=0
TOTAL_DEBUG=0
TOTAL_PHP=0

# Separate the excludes explicitilly to ensure the compatibility with grep.
EXCLUDE_DIRS="--exclude-dir=wp-admin --exclude-dir=wp-includes --exclude-dir=plugins --exclude-dir=themes --exclude-dir=node_modules --exclude-dir=vendor --exclude-dir=assets --exclude-dir=languages"

# Extensions that do not contain bussiness logic or real credentials.
EXCLUDE_FILES="--exclude=*.css --exclude=*.scss --exclude=*.less --exclude=*.svg --exclude=*.png --exclude=*.jpg --exclude=*.jpeg --exclude=*.gif --exclude=*.po --exclude=*.pot --exclude=*.mo --exclude=*.json --exclude=*.md --exclude=*.txt --exclude=*.map --exclude=*.min.js"

scan_and_report() {
    local title="$1"
    local grep_command="$2"
    local tmp_file
    tmp_file=$(mktemp)
    
    echo "--------------------------------------------------" >> "$REPORT_FILE"
    echo "[+] SCANNING: $title" >> "$REPORT_FILE"
    echo "--------------------------------------------------" >> "$REPORT_FILE"
    
    eval "$grep_command" > "$tmp_file"
    
    local count
    count=$(wc -l < "$tmp_file")
    
    if [ "$count" -eq 0 ]; then
        echo "    -> NO FINDINGS OR LEAKS DETECTED." >> "$REPORT_FILE"
    else
        cat "$tmp_file" >> "$REPORT_FILE"
    fi
    echo "" >> "$REPORT_FILE"
    
    rm -f "$tmp_file"
    echo "$count"
}

# 1. API keys & passwords
# The regex requires explicit asination and rejects lines that start with common comments.
# Ignore lines starting with *, // o #
grep_api="grep -rnPHo $EXCLUDE_DIRS $EXCLUDE_FILES '^[^#\/\*]*?\.{0,15}(api_key|api[-_]key|secret[-_]key|auth[-_]token|password|passwd|private[-_]key)\s*=\s*[\"'\''\\][a-zA-Z0-9_\.\-]{10,}[\"'\''\\]{0,15}' '$TARGET_DIR'"
TOTAL_API=$(scan_and_report "API keys, Passwords y Tokens" "$grep_api")
echo -e "    \e[32m[✓]\e[0m Credentials module completed."

# 2. Emails (Ignores native code & design extensions).
grep_emails="grep -rnPHo $EXCLUDE_DIRS $EXCLUDE_FILES '.{0,10}[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}.{0,10}' '$TARGET_DIR'"
TOTAL_EMAILS=$(scan_and_report "Emails" "$grep_emails")
echo -e "    \e[32m[✓]\e[0m Emails module completed."

# 3. Active debug functions (Exclude comments).
grep_debug="grep -rnPHo $EXCLUDE_DIRS $EXCLUDE_FILES '^[^#\/\*]*?\.{0,5}(print_r|var_dump|error_log|console\.log)\s*\(.*?\).{0,5}' '$TARGET_DIR'"
TOTAL_DEBUG=$(scan_and_report "Debug functions (Debug)" "$grep_debug")
echo -e "    \e[32m[✓]\e[0m Debug functions module completed."

# 4. phpinfo leaks.
grep_php="grep -rnPHo $EXCLUDE_DIRS $EXCLUDE_FILES '.{0,5}phpinfo\s*\(.*?\).{0,5}' '$TARGET_DIR'"
TOTAL_PHP=$(scan_and_report "System leaks (phpinfo)" "$grep_php")
echo -e "    \e[32m[✓]\e[0m phpinfo config module completed."

echo -e "\n==================================================" >> "$REPORT_FILE"
echo "END OF REPORT" >> "$REPORT_FILE"
echo "==================================================" >> "$REPORT_FILE"

# --- Render summary on the terminal ---
echo -e "\n\e[34m==================================================\e[0m"
echo -e "\e[34m               FINDINGS SUMMARY                    \e[0m"
echo -e "\e[34m==================================================\e[0m"

print_summary_line() {
    local name="$1"
    local quantity="$2"
    if [ "$quantity" -gt 0 ]; then
        echo -e "  $name: \e[1;31m$quantity alerts\e[0m"
    else
        echo -e "  $name: \e[32mClean (0)\e[0m"
    fi
}

print_summary_line "API keys y Tokens        " "$TOTAL_API"
print_summary_line "Emails                   " "$TOTAL_EMAILS"
print_summary_line "Debug functions          " "$TOTAL_DEBUG"
print_summary_line "phpinfo() exposition     " "$TOTAL_PHP"

echo -e "\e[34m==================================================\e[0m"
echo -e "\e[32m[✓] Scan successfully completed!\e[0m"
echo -e "\e[32m[✓] Saved report:\e[0m \e[1;36m$REPORT_FILE\e[0m"
echo -e "\e[34m==================================================\e[0m"
