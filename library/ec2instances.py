#!/usr/bin/python
DOCUMENTATION='''
---
module: ec2instances
version_added: 0.1
short_description: Fetches AWS instances
description:
 - This module returns/displays AWS instances.
author: Rajesh JVLN
options:
  name:
    description:
      - name for ec2instance configuration
      - This is a primary key and used for identification
    required: true
  region:
    description:
      - Region where AWS instances configured
    required: true  
'''
EXAMPLES='''
- ec2instances: region: us-west-2
- ec2instances: region: us-west-1 secret_pass: SECRETPASS
'''
def main():
  module=AnsibleModule(
    argument_spec={
      'secret_pass' : {'default':str(os.environ.get('AWS_ACCESS_KEY_ID')), },
      'access_key'  : {'default':str(os.environ.get('AWS_SECRET_ACCESS_KEY')),},
      'region'      : {'default':str(os.environ.get('AWS_REGION')),},
    },
  )
  args= {
    'changed'       : False,
    'failed'        : False,
    'secret_pass'   : module.params['secret_pass'],
    'access_key'    : module.params['access_key'],
    'region'        : module.params['region'],
  }
  try:
    import boto
    from  boto import ec2
  except ImportError,err:
    module.fail_json(msg=str(err), **args)
  
  if 'None' in [module.params['secret_pass'], module.params['access_key'], module.params['region']]:
    module.fail_json(msg="No AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY or AWS_REGION enviornment vars found")
 
  connection = ec2.connect_to_region(module.params['region'])
  if connection is None:
    module.fail_json(msg="Failed to connect to %s "%(module.params['region']), **args)
  results={'changed': False}
  instance_dict=dict()
  instance_types=list()
  reservations=connection.get_all_instances()
  instances = [ each_instance  for each_reserv in reservations for each_instance in each_reserv.instances ]
  for each_instance in instances:
    _current_inst=each_instance.__dict__
    _inst=dict()
    _inst['internal_name']=_current_inst['private_dns_name']
    _inst['short_name']=_current_inst['private_dns_name'].split('.')[0]
    _inst['ipaddress']=_current_inst['private_ip_address']
    _inst['instance_type']=_current_inst['instance_type']
    _inst['platform']=_current_inst['platform']
    _inst['placement']=str(_current_inst['_placement'])
    if not str(_current_inst['instance_type']) in instance_types:
      instance_types.append(str(_current_inst['instance_type']))
    instance_dict[_current_inst['id']]=_inst
  results['changed'] = True
  results['instances'] = instance_dict
  results['instance_types']=instance_types
  module.exit_json(**results)


from ansible.module_utils.basic import *
main()