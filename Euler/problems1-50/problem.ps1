$i = 1
$sum = 0

for ( $i ; $i -lt 1000 ; $i++)
{
    if ( ($i % 3 -eq 0) -or ($i % 5 -eq 0) )
    {
        $sum = $sum + $i
    }
}

$sum
