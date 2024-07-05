<?php
$koneksi = mysqli_connect ("localhost","root","","api_project");
$id_dokter = $_POST['id_dokter'];
$data = mysqli_query($koneksi, "delete from tb_dokter where id_dokter='$id_dokter'");
if($data){
    echo json_encode(array('message' => 'deleted!'));
}else{
    echo json_encode(array('message' => 'error!'));
}
?>