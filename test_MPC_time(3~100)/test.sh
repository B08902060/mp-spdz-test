#!/bin/sh
createMPC(){
    cd Programs/Source
    echo "a = sfloat.Array($1)" > averge_test$1.mpc
    echo "sum = 0" >> averge_test$1.mpc
    echo "for i in range($1):" >> averge_test$1.mpc
    echo "  a[i] = sfloat.get_input_from(i)" >> averge_test$1.mpc
    echo "  sum += a[i]" >> averge_test$1.mpc
    echo "sum = sum/$1" >> averge_test$1.mpc
    echo "print_ln('Results =%s',sum.reveal())" >> averge_test$1.mpc
    cd ../../
    ./compile.py averge_test$1
}
test(){
        ./Scripts/shamir.sh -N $1 averge_test$1 | grep 'Time' | cut -d " " -f 3
}
clear(){
    cd Player-Data/
    rm -rf Mem*
    cd ../
}
round(){
        sum=0.0
        echo "$1" > Player-Data/Input-P$1-0
        t=0
        for((i=1;i<=10;i++))
        do
                line=$(test $1)
                if [ "$line" = "" ]
                then 
                    echo "$1-$i. Failed" 
                else
                    now=`echo $line+$sum | bc -l`
                    sum=$now
                    echo "$1-$i. Sum=$sum , now=$line" >>test2.out
                    echo "$1-$i. Success" 
                    t=$(($t+1))
                fi
        done
        aver=`echo $sum/$t | bc -l`
        echo "$1: $aver /STimes=$t" >> test.out
        echo "$1: $aver" 
}

for((j=3;j<=100;j++))
do
        createMPC $j
        round $j
done