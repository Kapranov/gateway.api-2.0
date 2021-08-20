# README

## Please check out there are packages on kernel system for correct works an application

```
cmake-data_3.10.2-1ubuntu2.18.04.2_all.deb
cmake_3.10.2-1ubuntu2.18.04.2_amd64.deb
erlang-base_1%3a24.0.2-1_amd64.deb
erlang-crypto_1%3a24.0.2-1_amd64.deb
erlang-dev_1%3a24.0.2-1_amd64.deb
erlang-syntax-tools_1%3a24.0.2-1_amd64.deb
gperf_3.1-1_amd64.deb
libarchive13_3.2.2-3.1ubuntu0.7_amd64.deb
libgc1c2_1%3a7.4.2-8ubuntu1_amd64.deb
libjsoncpp1_1.7.4-3_amd64.deb
librhash0_1.3.6-2_amd64.deb
libsctp1_1.0.17+dfsg-2_amd64.deb

```

## Please install are packages on VPS

```
bash> sudo apt-get update
bash> sudo apt autoremove
bash> sudo apt-get install gcc
bash> sudo apt-get install make
bash> sudo apt-get install build-essential
bash> sudo apt-get install erlang-dev
bash> sudo apt install --reinstall make
bash> sudo apt install build-essential
bash> sudo apt-get -y install build-essential autoconf
bash> sudo apt-get -y install m4
bash> sudo apt-get -y install libncurses5-dev
bash> sudo apt-get -y install cmake
bash> sudo apt-get -y install gperf
```

## Compile an application in development enviroment

```
bash> cd gateway.api-2.0/development
bash> mix deps.get
bash> mix deps.update -all
bash> mix deps.get
bash> mix compile
bash> mix ecto.drop
bash> mix ecto.create
bash> mix ecto.mirate
bash> mix run apps//core/priv/repo/seeds.ex
bash> ./run.sh
```

## Compile an application in test enviroment

```
bash> cd gateway.api-2.0/development
bash> MIX_ENV=test mix compile
bash> MIX_ENV=test mix ecto.drop
bash> MIX_ENV=test mix ecto.create
bash> MIX_ENV=test mix ecto.mirate
bash> MIX_ENV=test iex -S mix
bash> mix test
```

### 26 July 2021 by Oleg G.Kapranov
