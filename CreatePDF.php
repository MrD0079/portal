<?php
class CreatePDF {
    /**
     * @var string $smarty Smarty
     */
    private $smarty;

    public function __construct(&$smarty){ // or &$smarty
        require_once "function.php";
        $this->smarty = $smarty;
    }

    /**
     * Create pdf file and return it or save on server
     *
     * @param $page_tpl_name Dir to tpl smarty file
     * @param $page_tpl_name Puth to tpl smarty file
     * @param $params Params for function: needed - page_tpl_puth, page_tpl_name, to_file, id, catalog
     * @param $data Symfony data to use in tpl file
     *
     * @return status
     *
     */
    public function create( $page_tpl_puth = "", $page_tpl_name = null, $params = array(), $data = array() ){
        $page_tpl_puth = $this->AddSlashToDir($page_tpl_puth);
        $is_pdf = $this->createPdf($page_tpl_puth, $page_tpl_name, $params, $data);
        if($is_pdf != "ok")
            return $this->getErrorDescr($is_pdf);
        else
            return true;
    }

    private function AddSlashToDir($dir_puth = ""){
        return ($dir_puth != "") ? (substr($dir_puth, -1) != "/") ? $dir_puth."/" : $dir_puth : "";
    }
    /**
     * Get error text by type
     *
     * @return $descr Error text
     */
    private function getErrorDescr($type){
        $descr = "";
        switch ($type){
            case "er1":
                $descr = "Page_tpl file not found";
                break;
            case "er2":
                $descr = "Not set page_tpl or it is empty";
                break;
            default:
                $descr = "Some error: ".$type;
        }
        return $descr;
    }

    /**
     * Create pdf file and return it or save on server
     *
     * @return error kod
     *
     */
    private function createPdf($page_tpl_puth, $page_tpl_name, $params, $data ) {
        if (is_null($page_tpl_name) || $page_tpl_name == "")
            return "er2";
        if(count(glob($page_tpl_puth.$page_tpl_name)) == 0)
            return "er1";

        try{
            if(count($data) > 0)
                $this->smarty->assign('data_tpl', $data);
            $a = $this->smarty->fetch($page_tpl_puth.$page_tpl_name);
        } catch (Exception $e) {
            return "".$e->getMessage();
        }
        //$a = "<p>Flag 1</p>";
        require_once("dompdf/dompdf_config.inc.php");
        $a = '<html>
            <head>
            <meta	http-equiv="Content-Type"	content="charset=utf-8" />
            <style type="text/css"> * {font-family: "DejaVu Sans Mono", monospace;}</style>
            </head>
            <body>
            ' . $a . '
            </body>
            </html>';

        //Check encoding
        //if(mb_detect_encoding($a,'Windows-1251')){
        $b = mb_convert_encoding($a, "UTF-8", "Windows-1251");
        //}else{
        //$b = $a;
        //}

        //Check needed params
        $params["id"] = isset($params["id"]) ? $params["id"] : 0;
        $params["file_name"] = isset($params["file_name"]) ? $params["file_name"]."_".$params["id"] : "file_".explode(".",$page_tpl_name)[0]."_".$params["id"];
        $params["to_file"] = isset($params["to_file"]) ? $params["to_file"] : 0;
        $params["catalog"] = $this->AddSlashToDir($params["catalog"]);

        // Output the generated PDF to Browser
        if (!$params["to_file"]) {
            try {

                $dompdf = new DOMPDF();

                $dompdf->load_html($b);

                $dompdf->render();
                //return $a;
                if (headers_sent($filename, $linenum)) {
                    echo $a;
                    return "\nHeaders was alredy send in $filename line: $linenum\n ( Use &print=1 )";
                }
                $dompdf->stream($params["file_name"].".pdf");
            } catch (Exception $e) {
                return "DomPDF: ".$e->getMessage();
            }
        } //Save on server created file
        else {
            try {
                require_once "local_functions.php";
                //check and create new directory
                $dir="files/".$params["catalog"];
                if (!file_exists($dir)) {mkdir($dir,0777,true);}
                $dompdf1 = new DOMPDF();
                $dompdf1->load_html($b);
                $dompdf1->render();
                file_put_contents($dir.$params["file_name"].".pdf", $dompdf1->output());
            } catch (Exception $e) {
                return "".$e->getMessage();
            }
        }
        return "ok";
    }
}
?>