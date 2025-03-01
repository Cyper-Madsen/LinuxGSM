#!/bin/bash
# LinuxGSM alert_telegram.sh module
# Author: Daniel Gibbs
# Contributors: http://linuxgsm.com/contrib
# Website: https://linuxgsm.com
# Description: Sends Telegram Messenger alert.

functionselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

json=$(cat <<EOF
{
	"chat_id": "${telegramchatid}",
	"parse_mode": "HTML",
	"text": "<b>${alertemoji} ${alertsubject} ${alertemoji}</b>\n\n<b>Server name</b>\n${servername}\n\n<b>Message</b>\n${alertbody}\n\n<b>Game</b>\n${gamename}\n\n<b>Server IP</b>\n<a href='https://www.gametracker.com/server_info/${alertip}:${port}'>${alertip}:${port}</a>\n\n<b>Hostname</b>\n${HOSTNAME}\n\n<b>More info</b>\n<a href='${alerturl}'>${alerturl}</a>",
	"disable_web_page_preview": "yes",
EOF
)

fn_print_dots "Sending Telegram alert"
telegramsend=$(curl --connect-timeout 10 -sSL -H "Content-Type: application/json" -X POST -d "$(echo -n "${json}" | jq -c .)" ${curlcustomstring} "https://${telegramapi}/bot${telegramtoken}/sendMessage" | grep "error_code")

if [ -n "${telegramsend}" ]; then
	fn_print_fail_nl "Sending Telegram alert: ${telegramsend}"
	fn_script_log_fatal "Sending Telegram alert: ${telegramsend}"
else
	fn_print_ok_nl "Sending Telegram alert"
	fn_script_log_pass "Sent Telegram alert"
fi
