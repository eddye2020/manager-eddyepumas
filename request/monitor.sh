#!/bin/bash

# Directorio destino
DIR=/var/www/html

# Nombre de archivo HTML a generar
ARCHIVO=monitor.html

# Fecha actual
FECHA=$(date +'%d/%m/%Y %H:%M:%S')

# Declaración de la función
EstadoServicio() {

    systemctl --quiet is-active $1
    if [ $? -eq 0 ]; then
        echo "<p>Estado del servicio $1 está || <span class='encendido'> ACTIVO</span>.</p>" >> $DIR/$ARCHIVO
    else
        echo "<p>Estado del servicio $1 está || <span class='detenido'> DESACTIVADO | REINICIANDO</span>.</p>" >> $DIR/$ARCHIVO
		service $1 restart &
NOM=`less /etc/newadm/ger-user/nombre.log` > /dev/null 2>&1
NOM1=`echo $NOM` > /dev/null 2>&1
IDB=`less /etc/newadm/ger-user/IDT.log` > /dev/null 2>&1
IDB1=`echo $IDB` > /dev/null 2>&1
KEY="862633455:AAGJ9BBJanzV6yYwLSemNAZAVwn7EyjrtcY"
URL="https://api.telegram.org/bot$KEY/sendMessage"
MSG="⚠️ AVISO DE VPS: $NOM1 ⚠️
❗️Protocolo $1 con fallo / Reiniciando❗️"
curl -s --max-time 10 -d "chat_id=$IDB1&disable_web_page_preview=1&text=$MSG" $URL
		
    fi
}

# Comienzo de la generación del archivo HTML
# Esta primera parte constitute el esqueleto básico del mismo.
echo "
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <meta http-equiv='X-UA-Compatible' content='ie=edge'>
  <title>Monitor de Servicios ADM-EDDYEPUMAS</title>
  <link rel='stylesheet' href='estilos.css'>
</head>
<body>
<h1>Monitor de Servicios By @EddyePumas</h1>
<p>Creditos: VPS-MX By @Kalix1</p>
<p id='ultact'>Última actualización: $FECHA</p>
<hr>
" > $DIR/$ARCHIVO




# Servicios a chequear (podemos agregar todos los que deseemos
# PROTOCOLO SSH
EstadoServicio ssh
# PROTOCOLO DROPBEAR
EstadoServicio dropbear
# PROTOCOLO SSL
EstadoServicio stunnel4
# PROTOCOLOSQUID
[[ $(EstadoServicio squid) ]] && EstadoServicio squid3
# PROTOCOLO APACHE
EstadoServicio apache2
on="<span class='encendido'> ACTIVO " && off="<span class='detenido'> DESACTIVADO | REINICIANDO "
[[ $(ps x | grep badvpn | grep -v grep | awk '{print $1}') ]] && badvpn=$on || badvpn=$off
echo "<p>Estado del servicio badvpn está ||  $badvpn </span>.</p> " >> $DIR/$ARCHIVO

#SERVICE BADVPN
PIDVRF3="$(ps aux|grep badvpn |grep -v grep|awk '{print $2}')"
if [[ -z $PIDVRF3 ]]; then
screen -dmS badvpn2 /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
NOM=`less /etc/newadm/ger-user/nombre.log` > /dev/null 2>&1
NOM1=`echo $NOM` > /dev/null 2>&1
IDB=`less /etc/newadm/ger-user/IDT.log` > /dev/null 2>&1
IDB1=`echo $IDB` > /dev/null 2>&1
KEY="862633455:AAGJ9BBJanzV6yYwLSemNAZAVwn7EyjrtcY"
URL="https://api.telegram.org/bot$KEY/sendMessage"
MSG="⚠️ AVISO DE VPS: $NOM1 ⚠️
❗️ Reiniciando BadVPN ❗️"
curl -s --max-time 10 -d "chat_id=$IDB1&disable_web_page_preview=1&text=$MSG" $URL
else
for pid in $(echo $PIDVRF3); do
echo""
done
fi

#SERVICE PYTHON DIREC
ureset_python () {
for port in $(cat /etc/newadm/PortPD.log| grep -v "nobody" |cut -d' ' -f1)
do
PIDVRF3="$(ps aux|grep pydic-"$port" |grep -v grep|awk '{print $2}')"
if [[ -z $PIDVRF3 ]]; then
screen -dmS pydic-"$port" python /etc/ger-inst/PDirect.py "$port"
NOM=`less /etc/newadm/ger-user/nombre.log` > /dev/null 2>&1
NOM1=`echo $NOM` > /dev/null 2>&1
IDB=`less /etc/newadm/ger-user/IDT.log` > /dev/null 2>&1
IDB1=`echo $IDB` > /dev/null 2>&1
KEY="862633455:AAGJ9BBJanzV6yYwLSemNAZAVwn7EyjrtcY"
URL="https://api.telegram.org/bot$KEY/sendMessage"
MSG="⚠️ AVISO DE VPS: $NOM1 ⚠️
❗️ Reiniciando Proxy-PhytonDirecto: $port ❗️ "
curl -s --max-time 10 -d "chat_id=$IDB1&disable_web_page_preview=1&text=$MSG" $URL
else
for pid in $(echo $PIDVRF3); do
echo""
done
fi
done
}

ureset_python

pidproxy3=$(ps x | grep -w  "PDirect.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy3 ]] && P3="<span class='encendido'> ACTIVO " || P3="<span class='detenido'> DESACTIVADO | REINICIANDO "
echo "<p>Estado del servicio PythonDirec está ||  $P3 </span>.</p> " >> $DIR/$ARCHIVO
#LIBERAR RAM,CACHE
#sync ; echo 3 > /proc/sys/vm/drop_caches ; echo "RAM Liberada"
# Finalmente, terminamos de escribir el archivo
echo "
<footer>
    <center><span class="badge badge-success"><font color="green">Visita</font>&nbsp;<a href="https://bit.ly/thonyblog">Mi Sitio Web Oficial</a></span></center>
                <center><div class="clearFloat"></div>
                <marquee><center><div class="copy"><p>&copy;<font color="#ff0000">2</font><font color="#ff1500">0</font><font color="#ff2a00">2</font><font color="#ff4000">0</font><font color="#ff5500"> </font><font color="#ff6a00">T</font><font color="#ff7f00">h</font><font color="#ff9400">o</font><font color="#ffaa00">n</font><font color="#ffbf00">y</font><font color="#ffd400">D</font><font color="#ffea00">r</font><font color="#ffff00">o</font><font color="#d5ff00">i</font><font color="#aaff00">d</font><font color="#80ff00"> </font><font color="#55ff00">M</font><font color="#2bff00">o</font><font color="#00ff00">n</font><font color="#00ff2b">i</font><font color="#00ff55">t</font><font color="#00ff80">o</font><font color="#00ffaa">r</font><font color="#00ffd5"> </font><font color="#00ffff">A</font><font color="#00d5ff">l</font><font color="#00aaff">l</font><font color="#0080ff"> </font><font color="#0055ff">R</font><font color="#002bff">i</font><font color="#0000ff">g</font><font color="#1700ff">h</font><font color="#2e00ff">t</font><font color="#4600ff">s</font><font color="#5d00ff"> </font><font color="#7400ff">R</font><font color="#8b00ff">e</font><font color="#9e00d5">s</font><font color="#b200aa">e</font><font color="#c50080">r</font><font color="#d80055">v</font><font color="#ec002b">e</font><font color="#ff0000">d</font></div></center></marquee>
</footer>
</body>
</html>" >> $DIR/$ARCHIVO
