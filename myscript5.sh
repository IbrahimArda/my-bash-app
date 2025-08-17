# Sistem yükünü cron ile uygulamak.
#Bu scripti cron ile 5 dakikada bir otomatik olarak çalışmasını sağlayacağım.

# cron a bir satır eklemek için 
# crontab -e 
#
#crnu ile 5 dk da bir scripti çalıştırma örneği:
#
# */5 * * * * /bin/bash $HOME/myscript4.sh
#
# eğer cron da yaptığımız birşeyi iptal etmek istiyorsak başına # ya da sil
#
# crontab -l -> crondaki görevleri gösterir
# crontab -r -> crondaki tüm görevleri gösterir.
#
# 

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

#LOG_FILE="$HOME/Documents/system_monitor.log"
# yukarıdaki log file kısmı github actionda çalışmaz. Github action runner ında # böyle bir dizin yok. Onun yerine ./system_monitor.log ya da /tmp/system_monitor.log yazarsak daha 
# doğru olur.

LOG_FILE="/tmp/system_monitor.log"

RAM_LIMIT=80
CPU_LIMIT=1
DISK_LIMIT=80

log_info(){ echo -e "$(date '+F% %T' ) ${BLUE}[INFO]${RESET} $1" | tee -a "$LOG_FILE"; }
log_warn(){ echo -e "$(date '+F% %T' ) ${YELLOW}[WARNING]${RESET} $1 " | tee -a "$LOG_FILE"; }
log_err(){
	echo -e "$(date '+F% %T' ) ${RED}[ERROR]${RESET} $1 " | tee -a "$LOG_FILE"; }
log_ok(){
	echo -e "$(date '+F% %T' ) ${GREEN}[SUCCESS]${RESET} $1 " | tee -a "$LOG_FILE"; }

check_cpu(){
	load=$( awk '{ print $1 }' /proc/loadavg)
	log_info "Cpu ilk 1 dk lık yükü alındı"

	load_int="${load%.*}"
	if (( load_int >= CPU_LIMIT )); then
		log_warning "CPU kullanımı kritik sevi"
	else 
		log_ok "Cpu kullanımı makul düzeyde"
	fi
}

check_ram(){
	ram_usage=$( free | awk '/Mem:/ { printf "%.0f", $3/$2 * 100 }')
	log_info "Kullanılan ram: $ram_usage%"
	if (( ram_usage >= RAM_LIMIT )); then
		log_warning "Ram kullanımı kritiek seviyede"
	else 
		log_ok "Ram kullanımı makul"
	fi
}

check_disk(){

	disk_usage=$( df / | awk 'NR==2 { gsub("%","",$5); print $5 }')
        log_info "Kullanılan disk: $disk_usage%"
        if (( disk_usage > DISK_LIMIT )); then
	 log_warning "Disk kullanımı kritik"
        else
         log_ok "Disk kullanımı makul"
        fi
}

main(){
	log_info "Script başlatıılıyor"
	check_cpu
	check_ram
	check_disk
	log_ok "Script başarıyla sonlandı"
}
main

