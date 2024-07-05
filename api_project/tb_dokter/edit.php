<?php
$koneksi = mysqli_connect ("localhost","root","","api_project");

$id_dokter = $_POST['id_dokter'];
$nama = $_POST['nama'];
$jabatan = $_POST['jabatan'];
$alamat = $_POST['alamat'];

$data = mysqli_query($koneksi, "update tb_dokter set nama='$nama', jabatan='$jabatan', alamat='$alamat' where id_dokter='$id_dokter'");
if($data){
    echo json_encode(array('message' => 'updated!'));
}else{
    echo json_encode(array('message' => 'error!'));
}
?>