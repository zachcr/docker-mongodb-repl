FROM dockerfile/mongodb

RUN sed -i 's/#replSet=setname/replSet=rs0/' /etc/mongod.conf
# Elaborate setup...
RUN mongod --config /etc/mongod.conf --fork; \
    echo "rs.initiate({_id: 'rs0', members:[{_id: 0, host: 'localhost'}]})" | mongo; \
    echo "Wating for mongo to initiate replSet..."; \
    while [ `echo "rs.status()" | mongo | grep '"myState" : 1,' | wc -l` -ne 1 ]; do sleep 1; done; \
    pkill mongod;

CMD ["mongod", "--config", "/etc/mongod.conf"]
