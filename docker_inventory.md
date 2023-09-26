bundle agent docker_inventory
{
  reports: "hi from ${this.bundle}";
}

root@314abd9230fd:/# cf-agent -KI
R: hi from docker_inventory

