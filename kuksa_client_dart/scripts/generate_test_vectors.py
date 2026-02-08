#!/usr/bin/env python3
########################################################################
# Copyright (c) 2025 Eclipse KUKSA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
########################################################################

"""
Test Vector Generator for KUKSA Dart Parity Tests
"""

import json
import sys
from datetime import datetime


def generate_test_vectors():
    """Generate test vectors for all data models"""
    
    vectors = {
        "version": "1.0.0",
        "generated": datetime.now().isoformat(),
        "tests": []
    }
    
    test_time = "2025-01-01T12:00:00"
    
    # Test 1: Simple Datapoint
    vectors["tests"].append({
        "name": "datapoint_simple",
        "type": "Datapoint",
        "input": {"value": 120.5, "timestamp": None},
        "expected": {"value": 120.5, "timestamp": None}
    })
    
    # Test 2: Datapoint with timestamp
    vectors["tests"].append({
        "name": "datapoint_with_timestamp",
        "type": "Datapoint",
        "input": {"value": 100, "timestamp": test_time},
        "expected": {"value": 100, "timestamp": test_time}
    })
    
    return vectors


def main():
    """Main function"""
    try:
        vectors = generate_test_vectors()
        print(json.dumps(vectors, indent=2))
        return 0
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
