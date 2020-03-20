from flask_restful import Resource, reqparse
from flask_jwt import jwt_required
from models.location import LocationModel


class Location(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('group_id',
                        type=int,
                        required=True,
                        help="Every location needs a group id."
    )

    def get(self, name):
        location = LocationModel.find_by_name(name)
        if location:
            return location.json()
        return {'message': 'Location not found'}, 404


    # @jwt_required()
    # def post(self, name, address, latitude, longitude):
    #     if LocationModel.find_by_name(name):
    #         return {'message': "A location with name '{}' already exists.".format(name)}, 400

    #     data = Location.parser.parse_args()

    #     location = LocationModel(name, **data) # (name, data['name'], data['school_id'])

    #     try:
    #         location.save_to_db()
    #     except:
    #         return {'message': 'An error ocurred inserting the location'}, 500

    #     return location.json(), 201

    @jwt_required()
    def post(self, name):
        if LocationModel.find_by_name(name):
            return {'message': "A location with name '{}' already exists.".format(name)}, 400

        data = Location.parser.parse_args()

        location = LocationModel(name, **data) # (name, data['name'], data['school_id'])

        try:
            location.save_to_db()
        except:
            return {'message': 'An error ocurred inserting the location'}, 500

        return location.json(), 201

    @jwt_required()
    def delete(self, name):
        location = LocationModel.find_by_name(name)
        if location:
            location.delete_from_db()

        return {'message': 'Location deleted'}


class LocationList(Resource):
    def get(self):
        return {'locations': list(map(lambda x: x.json(), LocationModel.query.all()))}