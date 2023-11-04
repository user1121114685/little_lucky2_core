package main

import "C"
import (
	"fmt"
	"github.com/alist-org/alist/v3/cmd"
	"github.com/alist-org/alist/v3/cmd/flags"
	"github.com/alist-org/alist/v3/diy"
	"strings"
	"time"
)

func main() {}

var AlistCommit = "小幸运内置Alist"

//export OutServerInit
func OutServerInit(port int, dir *C.char) {
	fmt.Println("正式启动 端口  ", port)
	flags.DataDir = C.GoString(dir)
	diy.SetVersion(AlistCommit)
	diy.SetConfAndPort(port)

	cmd.OutAlistInit()
}

//export OutServerTestInit
func OutServerTestInit(port int, dir *C.char) {

	fmt.Println("测试服务启动 .. 你有5秒时间启动服务器 ")
	time.Sleep(5 * time.Second)
}

//export SetAlistPassword
func SetAlistPassword(pass *C.char) *C.char {
	fmt.Println("调用了函数 设置密码 " + C.GoString(pass))
	//for !diy.GetStoragesLoaded() {
	//	time.Sleep(1 * time.Second)
	//}
	p := strings.Split(C.GoString(pass), "|---|")
	flags.DataDir = p[0]
	//diy.SetConfAndPort(randomInt())
	s := diy.SetPassword(p[1])
	if s == "" {
		s = diy.GetAdmin()
	}
	return C.CString(s)
}

