<?php


namespace PaypalAddons\classes\API\Response;


class Response
{
    /** @var $success bool*/
    protected $success;

    /** @var $error Error*/
    protected $error;

    protected $data;

    /**
     * @return bool
     */
    public function isSuccess()
    {
        return $this->success;
    }


    public function getError()
    {
        return $this->error;
    }

    public function setSuccess($success)
    {
        $this->success = (bool)$success;
        return $this;
    }

    public function getData()
    {
        return $this->data;
    }

    public function setData($data)
    {
        $this->data = $data;
        return $this;
    }

    public function setError(Error $error)
    {
        $this->error = $error;
        return $this;
    }
}
