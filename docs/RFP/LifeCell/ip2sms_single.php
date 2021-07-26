<?php
# ������ ������������ ��� �������� ���������� ��������� ������ ���������� ��� ������� �����(����� ����� ����� ��������� 3 ����). 

define('URL', 'https://api.life.com.ua/ip2sms/');

##################################################################################################################################
# ���� ��������� ��������������

define('LOGIN', '�����'); 		// ����� ������������
define('PASSWORD', '������'); 	// ������ ������������

$source = 'ALPHANAME'; 				// ��������, � �������� ����� ���������� ��� ���������. ������ ���� �������� ������������.
$destination = '+380���������'; 	// ����� ���������� ���������
$text = 'PRIVET IpSms'; 			// ����� ���������
###################################################################################################################################

###################################################################################################################################
# ����, ������� �� ����� �������������

$answ = post_request($source, $destination, $text);
echo $answ;

function post_request($source, $destination, $text)
{
    $headers = array('Authorization: Basic ' . base64_encode(LOGIN . ":" . PASSWORD), 'Content-Type: text/xml');
    $params = array('http' =>
        array(
            'method' => 'POST',
            'header' => implode("\r\n", $headers),
            'content' => '<?xml version="1.0" encoding="UTF-8" ?><message><service id="single" source="' . $source . '"/><to>' . $destination . '</to><body content-type="text/plain">' . htmlspecialchars($text) . '</body></message>'
    ));

    $ctx = stream_context_create($params);
    $fp = fopen(URL, 'rb', FALSE, $ctx);
    if($fp)
    {
        $response = stream_get_contents($fp);
        return $response;
    }else
    {
        return FALSE;
    }
}
?>
