<?php
declare(strict_types=1);

namespace App\Resolver;

use Doctrine\DBAL\Connection;

final class PongResolver
{
    /**
     * @var Connection
     */
    private $connection;

    /**
     * PongResolver constructor.
     * @param Connection $connection
     */
    public function __construct(Connection $connection)
    {
        $this->connection = $connection;
    }

    public function __invoke(string $text)
    {
        return 'PONG '.(new \DateTime())->format('Y-m-d H:i:s');
    }
}