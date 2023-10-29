variable "developers" {
  description = "List of developers"
  type = list(string)
  default = [ "Pawan", "Varun", "Hari", "Gokul" ]
}
variable "give_hari_cloudwatch_full_access" {
  description = "If trie , Hari gets full access to Cloudwatch"
  type = bool
}