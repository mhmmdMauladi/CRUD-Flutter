<?php
$koneksi = mysqli_connect ("localhost","root","","api_project");
$nama = $_POST['nama'];
$jabatan = $_POST['jabatan'];
$alamat = $_POST['alamat'];
$data = mysqli_query($koneksi, "insert into tb_dokter set nama='$nama', jabatan='$jabatan', alamat='$alamat'");
if($data){
    echo json_encode(array('message' => 'created!'));
}else{
    echo json_encode(array('message' => 'error!'));
}
?>