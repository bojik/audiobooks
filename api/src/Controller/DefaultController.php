<?php
declare(strict_types=1);

namespace App\Controller;

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\Exception;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

final class DefaultController extends AbstractController
{
    /**
     * @Route("/", name="index")
     * @param Connection $connection
     * @throws Exception
     */
    public function index(Connection $connection)
    {
        $users = $connection->fetchAllAssociative('select * from app_user limit 10');
    }
}
