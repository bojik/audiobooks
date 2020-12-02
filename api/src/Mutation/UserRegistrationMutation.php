<?php
declare(strict_types=1);

namespace App\Mutation;

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\Exception;
use GraphQL\Error\Error;
use Overblog\GraphQLBundle\Definition\Resolver\MutationInterface;

final class UserRegistrationMutation implements MutationInterface
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

    /**
     * @param string $userLogin
     * @param string $userPassword
     * @param string $publicName
     * @return int
     * @throws Exception
     * @throws Error
     * @throws \Exception
     */
    public function __invoke(string $userLogin, string $userPassword, string $publicName)
    {
        $data = json_encode(['public_name' => $publicName, 'registration_methods_id' => 1]);
        $res = $this->connection->fetchAssociative('CALL user_register(?, ?, ?)', [$userLogin, $userPassword, $data]);
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
