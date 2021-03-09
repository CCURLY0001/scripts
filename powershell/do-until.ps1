#Basic Do-While Less Than statement to pass variable against command.

$i=1

do
{
aws s3 rb s3://cristian-aws-bucket-$i
$i++
} while ($i -lt 4)
