go mod init ${REPO_OWNER}/${REPO_NAME}
touch main.go

echo 'package main' >>main.go
echo '' >>main.go
echo 'import "fmt"' >>main.go
echo '' >>main.go
echo 'func main() {' >>main.go
echo '    fmt.Println("Hello, World!")' >>main.go
echo '}' >>main.go
