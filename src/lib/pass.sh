
# Ask the vault to show the ouput of a password
pass_show ()
{
    local password
    password=$(qvm-pass "${@}" | head -n 1)

	#copies the password to clipboard
	echo -n "${password}" | xclip -selection clipboard
	echo "Password has been saved in clipboard"
	echo "Press CTRL+V to use the content in this qube"
	echo "Press CTRL+SHIFT+C to share the clipboard with another qube"
	echo "In the other qube, press CTRL+SHIFT+v and then CTRL+V to use the clipboard content"
	echo "Local clipboard will be erased is ${PASS_TIMEOUT} seconds"
    ( sleep "${PASS_TIMEOUT}"; echo -n "" |xclip -selection clipboard;) &
}

# Ask the vault to show the output of a password, and clear
# the clipboard after one paste event/action.
pass_show_once ()
{
    local password
    password=$(qvm-pass "${@}" | head -n 1)

	#copies the password to clipboard
	echo -n "${password}" | xclip -selection clipboard -loops 1 
	echo "Password has been saved in clipboard"
	echo "Local clipboard will be erased after 1 use"
}
