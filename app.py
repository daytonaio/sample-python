#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------
from os import environ as env
import argparse
from flask import Flask

app = Flask(__name__)

parser = argparse.ArgumentParser()
parser.add_argument("-w", "--workspace",
                    default=env.get('DAYTONA_WS_ID', 'user-repo-abcd1234'))
parser.add_argument("-d", "--domain",
                    default=env.get('DAYTONA_WS_DOMAIN', 'daytona.io'))
parser.add_argument("-p", "--port", type=int,
                    default=5000,
                    metavar="[1024-65534]",
                    choices=range(1024,65534))

args = parser.parse_args()

workspace = args.workspace
domain = args.domain
port = args.port

@app.route("/")
def hello():
    return "Hello World! from https://" + str(port) + "-" + workspace + "." + domain

if __name__ == "__main__":
   app.run(host="localhost", port=port, debug=True)


