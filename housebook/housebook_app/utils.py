import uuid

def generate_uid():
    value = int(uuid.uuid4().int & (1<<16)-1)
    return value