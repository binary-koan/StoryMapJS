"""
S3-based storage backend

Object Keys
http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html
"""
import os
import sys
import time
import traceback
import json
from functools import wraps
import boto3
import botocore
from botocore.client import ClientError
from moto import mock_s3
import requests

# Get settings module
settings = sys.modules[os.environ['FLASK_SETTINGS_MODULE']]


if settings.TEST_MODE:
    _mock = mock_s3()
    _mock.start()

    _conn = boto3.resource('s3')
    _bucket = _conn.Bucket(settings.AWS_STORAGE_BUCKET_NAME)

    _mock.stop()
else:
    _conn = boto3.resource('s3', endpoint_url='http://127.0.0.1:9000')
    _bucket = _conn.Bucket(settings.AWS_STORAGE_BUCKET_NAME)

class StorageException(Exception):
    """
    Adds 'detail' attribute to contain response body
    """
    def __init__(self, message, detail):
        super(Exception, self).__init__(message)
        self.detail = detail


def _mock_in_test_mode(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if settings.TEST_MODE:
            _mock.start(reset=False)
            result = f(*args, **kwargs)
            _mock.stop()
            return result
    return decorated_function


def _reraise_s3response(f):
    """Decorator trap and re-raise S3ResponseError (ClientError) as StorageException"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        try:
            return f(*args, **kwargs)
        except ClientError, e:
            print traceback.format_exc()
            raise StorageException(e, "")
    return decorated_function


def key_id():
    """
    Get id for key
    """
    return repr(time.time())

def key_prefix(*args):
    return '%s/%s/' % (settings.AWS_STORAGE_BUCKET_KEY, '/'.join(args))

def key_name(*args):
    return '%s/%s' % (settings.AWS_STORAGE_BUCKET_KEY, '/'.join(args))


@_reraise_s3response
@_mock_in_test_mode
def list_keys(key_prefix, n, marker=''):
    """
    List keys that start with key_prefix (<> key_prefix itself)
    @n = number of items to return
    @marker = name of last item
    """
    key_list = []
    i = 0

    for i, item in enumerate(_bucket.objects.all()):
        if i == n:
            break
        if item.name == key_prefix:
            continue
        key_list.append(item)
    return key_list, (i == n)


@_mock_in_test_mode
def all_keys():
    for item in enumerate(_bucket.objects.all()):
        if item.name == key_prefix:
            continue
        yield item.key


@_reraise_s3response
@_mock_in_test_mode
def list_key_names(key_prefix, n, marker=''):
    """
    List key names that start with key_prefix (<> key_prefix itself)
    @n = number of items to return
    @marker = name of last item
    """
    name_list = []
    i = 0

    for i, item in enumerate(_bucket.objects.all()):
        if i == n:
            break
        if item.name == key_prefix:
            continue
        name_list.append(item.name)
    return name_list, (i == n)

@_reraise_s3response
@_mock_in_test_mode
def copy_key(src_key_name, dst_key_name):
    """
    Copy from src_key_name to dst_key_name
    """
    dst_key = _bucket.copy_key(dst_key_name, _bucket.name, src_key_name)
    dst_key.set_acl('public-read')

@_reraise_s3response
@_mock_in_test_mode
def save_from_data(key_name, content_type, content):
    """
    Save content with content-type to key_name
    """
    key = _bucket.get_key(key_name)
    if not key:
        key = _bucket.new_key(key_name)
        key.content_type = content_type
    key.set_contents_from_string(content, policy='public-read')

@_reraise_s3response
@_mock_in_test_mode
def save_from_url(key_name, url):
    """
    Save file at url to key_name
    """
    r = requests.get(url)
    save_from_data(key_name, r.headers['content-type'], r.content)

@_reraise_s3response
@_mock_in_test_mode
def load_json(key_name):
    """
    Get contents of key as json
    """
    key = _bucket.get_key(key_name)
    contents = key.get_contents_as_string()
    return json.loads(contents)

@_reraise_s3response
@_mock_in_test_mode
def save_json(key_name, data):
    """
    Save data to key_name as json
    """
    if type(data) in [type(''), type(u'')]:
        content = data
    else:
        content = json.dumps(data)
    save_from_data(key_name, 'application/json', content)

@_reraise_s3response
@_mock_in_test_mode
def delete(key_name):
    """
    Delete key
    """
    _bucket.delete_key(key_name)
