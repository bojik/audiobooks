<?php
declare(strict_types=1);

namespace App\Mutation;

use Doctrine\DBAL\Connection;
use GraphQL\Error\Error;
use Overblog\GraphQLBundle\Definition\Resolver\MutationInterface;

final class UserPasswordRestoreMutation implements MutationInterface
{
    /**
     * @var Connection
     */
    private $connection;

    /**
     * UserRegistrationMutation constructor.
     * @param Connection $connection
     */
    public function __construct(Connection $connection)
    {
        $this->connection = $connection;
    }

    public function __invoke(string $login, string $code, string $password)
    {
        $res = $this->connection->fetchAssociative('CALL user_restore_password(?, ?, ?)', [$login, $code, $password]);
        if (!array_key_exists('success', $res) || !array_key_exists('payload', $res)) {
            throw new \Exception('Invalid result');
        }
        $success = boolval($res['success']);
        $payload = json_decode($res['payload'], true);
        if (!$success) {
            throw new Error($payload['message']);
        }
        return $payload['user_id'];
    }
}
