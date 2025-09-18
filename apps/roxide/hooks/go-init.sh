set -e

if [[ -n "${REMOTE_CLONE}" ]]; then
	mod_name="${REMOTE_CLONE}/${OWNER_NAME}/${REPO_NAME}"
else
	mod_name="test/${REPO_NAME}"
fi

echo "Go module name: ${mod_name}"
go mod init "${mod_name}"
touch main.go

echo 'package main' >>main.go
echo '' >>main.go
echo 'import "fmt"' >>main.go
echo '' >>main.go
echo 'func main() {' >>main.go
echo '    fmt.Println("Hello, World!")' >>main.go
echo '}' >>main.go
