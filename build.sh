export USER='root'
export PASSWORD='password_mysql'
export DATABASE_URL='mysql://10.5.1.75:3306/dev?useTimezone=true&serverTimezone=UTC'
cd build

mvn package
