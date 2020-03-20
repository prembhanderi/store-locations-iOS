from db import db


class LocationModel(db.Model):
    __tablename__ = 'locations'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))

    group_id = db.Column(db.Integer, db.ForeignKey('groups.id'))
    group = db.relationship('GroupModel')

    # def __init__(self, name, address, latitude, longitude, group_id):
    #     self.name = name
    #     self.group_id = group_id
    #     self.address = address
    #     self.latitude = latitude
    #     self.longitude = longitude

    def __init__(self, name, group_id):
        self.name = name
        self.group_id = group_id


    # def json(self):
    #     return {'name': self.name,
    #             'address': self.address, 
    #             'latitude': self.latitude, 
    #             'longitude': self.longitude, 
    #             'group': self.group.name}

    def json(self):
        return {'name': self.name, 'group': self.group.name}

    @classmethod
    def find_by_name(cls, name):
        return cls.query.filter_by(name=name).first()

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
