# OodCluster

A library used to describe an HPC center cluster and its resources.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ood_cluster'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install ood_cluster
```

## Usage

Typically you would read in all the cluster information from a YAML file. There
is an example yaml configuration file included with this repo:

```ruby
require 'ood_cluster'

# Read in example json file for OSC clusters
require 'json'
JSON.create_id = "type"
osc_clusters = JSON.load(File.read("config/clusters.json"))['v1']
#=>
#{
#  "oakley" => #<OodCluster::Cluster>,
#  "ruby"   => #<OodCluster::Cluster>,
#  "quick"  => #<OodCluster::Cluster>,
#}

# Read in example yaml file for OSC clusters
require 'yaml'
osc_clusters = JSON.load(JSON.dump(YAML.load(File.read("config/clusters.yml"))))['v1']
#=>
#{
#  "oakley" => #<OodCluster::Cluster>,
#  "ruby"   => #<OodCluster::Cluster>,
#  "quick"  => #<OodCluster::Cluster>,
#}
```

Given a cluster object you could then get connection information for the
various servers hosted by the cluster.

```ruby
# Play with the Oakley cluster
oakley = osc_clusters["oakley"]
#=> #<OodCluster::Cluster>

# Check if Oakley has a Resource Manager server
oakley.resource_mgr_server?
#=> true

# Check the type of server this is
oakley.resource_mgr_server.class
#=> OodCluster::Servers::Torque

# Get the status of this Torque server through the pbs-ruby library
oakley.resource_mgr_server.pbs.get_status
#=>
#{
#  "oak-batch.osc.edu:15001" => {
#    :server_state => "Idle",
#    :total_jobs => "1866",
#    :default_queue => "batch",
#    ...
#  }
#}
```

Not only can you query the various servers, you can also query reservation
information if it is available for the given cluster:

```ruby
# Check if this cluster handles reservations
oakley.reservations?
#=> true

# Get reservations for currently running user
oakley.reservations
#=>
#[
#  #<OodCluster::Reservation>,
#  #<OodCluster::Reservation>
#]
```

### Servers

From the cluster you can query server information using the following syntax:

```ruby
# Check whether server exists on this cluster
#   my_cluster.<server>_server?
my_cluster.ganglia_server?
#=> true

# Grab the server object
#   my_cluster.<server>_server
ganglia = my_cluster.ganglia_server
#=> #<OodCluster::Servers::Ganglia>
```

#### Torque

This can be a `resource_mgr_server` for a cluster. It uses the `pbs` gem
library for communication with this server:

```ruby
# Assign torque server
torque_server = my_cluster.resource_mgr_server
#=> #<OodCluster::Servers::Torque>

# Get host information
torque_server.host
#=> "oak-batch.osc.edu"

# Get client software information
torque_server.prefix.to_s
#=> "/usr/local/torque/default"

# Get the pbs object
torque_server.pbs
#=> #<PBS::Batch>
```

Please see https://github.com/OSC/pbs-ruby/ for more information on how to use
the `pbs` object.

#### Moab

This can be a `scheduler_server` for a cluster. It comes with a generic `moab`
object that allows for communication with this server:

```ruby
# Assign moab server
moab_server = my_cluster.scheduler_server
#=> #<OodCluster::Servers::Moab>

# Get host information
moab_server.host
#=> "oak-batch.osc.edu"

# Get client software information
moab_server.prefix.to_s
#=> "/usr/local/moab/default"

# Get the generic moab object
moab_server.moab
#=> #<PBS::Servers::Moab::Scheduler>
```

Communication is handled through this `moab` object by calling system-installed
binaries. The output of the command called with be given in the XML format and
handled by the `nokogiri` gem.

```ruby
# Get generic moab object used for communication with Moab server
moab = moab_server.moab

# Call `mrsvctl` for this Moab server
moab.call("mrsvctl", "-q", "ALL").xpath("//rsv/@Name").first.value
#=> "my_rsv.832749"

# Call `showq` for this Moab server
moab.call("showq").xpath('//queue[@option="active"]/@count').first.value.to_i
#=> 639
```

#### Ganglia

If a cluster has a ganglia server, then communication is handled client side
through the browser. So the responsibility of the Ganglia server object is to
generate URIs for the client.

```ruby
# Get URI used to access the web server
ganglia_server.uri.to_s
#=> "https://www.hpc.edu/gweb/graph.php?c=MyCluster"

# Add query values as options for the server
ganglia_server.uri(query_values: {g: 'cpu_report'}).to_s
#=> "https://www.hpc.edu/gweb/graph.php?c=MyCluster&g=cpu_report"
```

### Reservations

If a cluster handles querying for reservations, you should be able to retrieve
all the reservations available for the current user or you can specify a
specific reservation. It will return to you a list of or a single reservation
object respectively.

```ruby
# Check if cluster allows reservation querying
my_cluster.reservations?
#=> true

# Get first reservation in list
my_rsv = my_cluster.reservations.first
#=> #<OodCluster::Reservation>

# Has this reservation started yet?
my_rsv.has_started?
#=> true

# Has this reservation ended yet?
my_rsv.has_ended?
#=> false

# Get list of users/groups that have access to this reservation
my_rsv.users.map(&:name)
#=> ["bob", "sally", "me"]

my_rsv.groups.map(&:name)
#=> ["group1", "group2"]

# List all nodes on reservation
my_rsv.nodes.map(&:id)
#=> ["n0001", "n0002"]

# List nodes that have no jobs running on them
my_rsv.free_nodes.map(&:id)
#=> ["n0002"]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ood_cluster/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
