
cd "C:\Users\mvher\Documents\Repositories"

gcl() {
	git clone "$1"
}

gst() {
	git status
}

ga() {
	git add
}

gaa() {
	git add .
}

gco() {
	git commit -m "$1"
}

gpl() {
	git pull
}

gps() {
	git push
}

# gp() {
	#gets repo name and pushes (first push)
# }

gck(){
	git checkout
}

gckm() {
	git checkout master
}

gd() {
	git diff
}

ahk() {
	cd "C:\Users\mvher\Documents\Repositories\ahk"
	git pull
}

