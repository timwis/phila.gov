[![Tested on BrowserStack](https://img.shields.io/badge/browserstack-tested-brightgreen.svg?logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAACsUlEQVQokVWSTWwUZQCGn2%2B%2Bnd2d7XS7K1v6Q6WAaBoKklAMP0rcNBqWiMET0SskxEBAURLjBfZkPJAQWmOswkVjYnqiKiGALQ0NP0EIcjAg0gottNB26f7Odmfmm89TG31P7%2BF5bo%2FgP%2BvX%2FfKto31bmY3vV2O590VJIlKps5FS0Fv35roRkc06C6xYOLkvt3cyWTmh7wdve402411Jys0GNkWSUxXij%2Bw79S1N2brPTp9ZFJ9lM6%2FKfP5c%2BK7ZOvpGmsHMu9wImnjmgUWeDeavpNUQa25ZKpVq%2FST6wbc9QvccjExP3LhkPdJbxpdnOL%2FnEAMPKzy48gve%2BH2q7Wuo37Sdd2Kn2BW7wusPG%2F1k%2B4sZIzd9d1tYqS3lis2Tne8xWoHJn05g9h1jxa2LfLfKRI4McNPdyG03zMyyaqhWLB41dCT2EZ7Ci8bxUimCuVn0zUuIcBSzPs7fo2OI4Z%2BpuYrn8yEeWwGE1CaD%2BWLaB5Rw8P0SrzTGCSdSaOUz%2BWSSvq96cRNLWW1X0TrAV2CGRMQILWseMySYco78P0O8tDTB7sOf09KxFqvOZslrabr37aVD%2Fo4hBY1ljVCCkGyI9UgrciqWcGm6eoY%2F2iKs27iDzm9%2BoJzP4cZqTJcHmCg9oEv6rJyL4b0gnFD91uVn8zNTszhPU13FAoULP3K9awRpNwOK0swEQVBhveuTGXdJdLRRM4zLAsD5bd%2Bn8t7E8cJfTzF8eNwQ5l6zScmSWAhWFmq8XDVIrm9HJ%2BuqfhDtFgBa98va8OBJOZU74IxO4z93EF4AhsCImpitDcQ6W1ARs%2Br55odW99ffLyaH1sK99vEeUXOOaGe%2BQypFIDQh28IThhJCXvZ1%2BJiV7h35X6uL%2Fp9Z2y8WNiOj25BWp67NDaOMa18MHr%2BdzYpggfsXmkch023E8JUAAAAASUVORK5CYII%3D)](https://www.browserstack.com/)


# phila.gov

The phila.gov site is WordPress running behind Nginx on an AWS instance. The entire machine setup is kept in this repo. 


## Running a test instance

1. [Install joia](https://github.com/CityOfPhiladelphia/joia#install)
2. Copy `.env.test` from S3 to `.env` in this repo
4. Run `joia up`


## Launching a new production instance

Same as above for test instance but replace `.env` with `.env.prod`. Then, after machine is up:

1. Set branch and project tags in AWS for Travis deploy (unsetting tags on current production instance)
2. Restart most recent build in Travis
3. After deploy has succeeded, add instance to load balancer
4. Once instance status is InService, remove and terminate old instance
