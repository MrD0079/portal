<?php
/**
 * Created by PhpStorm.
 * User: Taras.Daragan
 * Date: 12.02.2020
 * Time: 9:09
 */


$date = new DateTime();
$fp = fopen('/srv/www/1.txt', 'w+');
ob_start();
var_dump(['save' => $date->format('Y-m-d H:i:s') ]);
fwrite($fp, ob_get_clean());


$path="files/bud_ru_zay_files/198066216/sup_doc";

$fp = fopen('/srv/www/1.txt', 'a+');
ob_start();
var_dump(["getFilesPerms" => getFilesPerms($path)]);
fwrite($fp, ob_get_clean());

$fp = fopen('/srv/www/1.txt', 'a+');
ob_start();
var_dump(["getServerInfo" => getServerInfo($path)]);
fwrite($fp, ob_get_clean());

$fp = fopen('/srv/www/1.txt', 'a+');
ob_start();
var_dump(["file_exists" => file_exists($path)]);
fwrite($fp, ob_get_clean());

if (!file_exists($path)) {

    try{
        $mkdir = mkdir($path,0777,true);

        $fp = fopen('/srv/www/1.txt', 'a+');
        ob_start();
        var_dump(["mkdir" => $mkdir]);
        fwrite($fp, ob_get_clean());

    }catch (Exception $e){
        $fp = fopen('/srv/www/1.txt', 'a+');
        ob_start();
        var_dump($e->getMessage());
        fwrite($fp, ob_get_clean());
    }


}

function get_ip_address(){
    $result = [];
    foreach (array('HTTP_CLIENT_IP', 'HTTP_X_FORWARDED_FOR', 'HTTP_X_FORWARDED', 'HTTP_X_CLUSTER_CLIENT_IP', 'HTTP_FORWARDED_FOR', 'HTTP_FORWARDED', 'REMOTE_ADDR') as $key){
        if (array_key_exists($key, $_SERVER) === true){
            foreach (explode(',', $_SERVER[$key]) as $ip){
                $ip = trim($ip); // just to be safe

                if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) !== false){
                    $result[] = $ip;
                }
            }
        }
    }
    return $result;

}

function get_ip_address_x_forward(){
    $result = [];
    // check for IPs passing through proxies
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))
    {
        $iplist = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);

        foreach ($iplist as $ip)
        {
            if ($this->validate_ip($ip))
                $result[] = $ip;
        }
    }
    return $result;
}

function getFilesPerms($fileName){
    $perms = fileperms($fileName);

    switch ($perms & 0xF000) {
        case 0xC000: // сокет
            $info = 's';
            break;
        case 0xA000: // символическая ссылка
            $info = 'l';
            break;
        case 0x8000: // обычный
            $info = 'r';
            break;
        case 0x6000: // файл блочного устройства
            $info = 'b';
            break;
        case 0x4000: // каталог
            $info = 'd';
            break;
        case 0x2000: // файл символьного устройства
            $info = 'c';
            break;
        case 0x1000: // FIFO канал
            $info = 'p';
            break;
        default: // неизвестный
            $info = 'u';
    }

// Владелец
    $info .= (($perms & 0x0100) ? 'r' : '-');
    $info .= (($perms & 0x0080) ? 'w' : '-');
    $info .= (($perms & 0x0040) ?
        (($perms & 0x0800) ? 's' : 'x' ) :
        (($perms & 0x0800) ? 'S' : '-'));

// Группа
    $info .= (($perms & 0x0020) ? 'r' : '-');
    $info .= (($perms & 0x0010) ? 'w' : '-');
    $info .= (($perms & 0x0008) ?
        (($perms & 0x0400) ? 's' : 'x' ) :
        (($perms & 0x0400) ? 'S' : '-'));

// Мир
    $info .= (($perms & 0x0004) ? 'r' : '-');
    $info .= (($perms & 0x0002) ? 'w' : '-');
    $info .= (($perms & 0x0001) ?
        (($perms & 0x0200) ? 't' : 'x' ) :
        (($perms & 0x0200) ? 'T' : '-'));

    return $info;
}

function getServerInfo(){
    $info = [];

    $info['SERVER_PROTOCOL'] = $_SERVER['SERVER_PROTOCOL'];
    $info['REQUEST_METHOD'] = $_SERVER['REQUEST_METHOD'];
    $info['QUERY_STRING'] = $_SERVER['QUERY_STRING'];
    $info['REMOTE_ADDR'] = $_SERVER['REMOTE_ADDR'];
    $info['REMOTE_HOST'] = $_SERVER['REMOTE_HOST'];
    $info['REMOTE_PORT'] = $_SERVER['REMOTE_PORT'];
    $info['REMOTE_USER'] = $_SERVER['REMOTE_USER'];
    $info['REDIRECT_REMOTE_USER'] = $_SERVER['REDIRECT_REMOTE_USER'];
    $info['SERVER_PORT'] = $_SERVER['SERVER_PORT'];
    $info['SCRIPT_NAME'] = $_SERVER['SCRIPT_NAME'];
    $info['PHP_AUTH_PW'] = $_SERVER['PHP_AUTH_PW'];
    $info['SCRIPT_NAME'] = $_SERVER['SCRIPT_NAME'];

    return $info;
}