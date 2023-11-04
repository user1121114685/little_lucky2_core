package diy

import (
	"github.com/alist-org/alist/v3/cmd"
	"github.com/alist-org/alist/v3/cmd/flags"
	"github.com/alist-org/alist/v3/internal/conf"
	"github.com/alist-org/alist/v3/internal/op"
	"github.com/alist-org/alist/v3/pkg/utils"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"path/filepath"
)

func SetConfAndPort(prot int) {
	configPath := filepath.Join(flags.DataDir, "config.json")
	log.Infof("reading config file: %s", configPath)
	conf.Conf = conf.DefaultConfig()
	conf.Conf.Scheme.HttpPort = prot
	if !utils.WriteJsonToFile(configPath, conf.Conf) {
		log.Fatalf("failed to create default config file")
	}
}

func SetPassword(pass string) string {
	log.Println("当前设置的密码是 " + pass)
	cmd.SetPasswordCmd.Run(&cobra.Command{}, []string{pass})
	cmd.Init()
	//defer cmd.Release()
	admin, err := op.GetAdmin()
	if err != nil {
		log.Println("当前获取用户名错误 " + err.Error())
		return ""
	}
	return admin.Username
}

func GetAdmin() string {
	cmd.Init()
	//defer cmd.Release()
	admin, _ := op.GetAdmin()
	return admin.Username
}

func SetVersion(v string) {
	conf.Version = v
}

// GetStoragesLoaded 看看Alist是否已经启动了完成了
func GetStoragesLoaded() bool {
	return conf.StoragesLoaded
}
