from flask import Flask, request
from flask_restful import Resource, Api
from flask_jwt import JWT

from security import authenticate, identity
from resources.user import UserRegister
from resources.location import Location, LocationList
from resources.groups import Group, GroupList

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.secret_key = 'prembh'
api = Api(app)


class HelloWorld(Resource):
    def get(self):
        return {'about': 'Hello World!'}

    def post(self):
        some_json = request.get_json()
        return {'you sent': some_json}, 201


class MultiplyByTen(Resource):
    def get(self, num):
        return {'result': num*10}


@app.before_first_request
def create_tables():
    db.create_all()

jwt = JWT(app, authenticate, identity)
api.add_resource(HelloWorld, '/')
api.add_resource(MultiplyByTen, '/multiplybyten/<int:num>')

api.add_resource(Group, '/group/<string:name>')
api.add_resource(Location, '/location/<string:name>')
api.add_resource(GroupList, '/groups')
api.add_resource(LocationList, '/locations')

api.add_resource(UserRegister, '/register')

if __name__ == '__main__':
    from db import db
    db.init_app(app)
    app.run(port=5000, debug=True)
