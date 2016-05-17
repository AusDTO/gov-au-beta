class ContentLinter

  def initialize(content)
    @content = content
  end

  def parse
    word_suggestions
  end

  private
  def word_suggestions
    {
      'State and Territory' => 'state and territory',
      'Local Governments' => 'local governments',
      'a number of' => 'some, many, few',
      'address this issue' => 'look for solutions, solve this problem',
      'approximately' => 'about',
      'adequate number of' => 'enough',
      'aggregated' => 'total',
      'amongst' => 'among',
      'as a consequence of' => 'because',
      'ascertain' => 'find out',
      'assist' => 'help',
      'at a later date' => 'later',
      'at the time of writing' => 'now',
      'at this point in time' => 'now',
      'cognisant of' => 'aware of, know',
      'collaborate with' => 'working with',
      'commence' => 'start, begin',
      'Commonwealth Government' => 'Australian Government',
      'Federal Government' => 'Australian Government',
      'concerning' => 'about',
      'consequently' => 'so',
      'create a dialogue with them' => 'speak to people',
      'deliver, drive' => 'say what you are doing eg increasing …',
      'despite the fact that' => 'although, despite',
      'disburse' => 'pay',
      'discontinue' => 'stop',
      'dispatch' => 'send',
      'documentation' => 'documents',
      'due to the fact that' => 'because, since, as',
      'during the month of' => 'in',
      'establish' => 'create, set-up, form',
      'examine' => 'look at, check, discuss',
      'facilitate' => 'help',
      'give consideration to' => 'think about, consider',
      'going forward' => 'future',
      'have the capacity to' => 'can',
      'identify' => 'set, create, decide on, know, recognise',
      'if this is not the case' => 'if not',
      'if this is the case' => 'if so',
      'impact upon' => 'affect',
      'in accordance with' => 'in line with',
      'implement' => 'apply, install, do',
      'in order to' => 'to',
      'in receipt of' => 'get, have, receive, receiving',
      'in relation to' => 'about',
      'in the event of, in the event that' => 'if when',
      'in the event that' => 'if',
      'in the light of, in view of' => 'because',
      'it is requested that you declare' => 'you should declare',
      'it should be noted that' => 'note that, remember that',
      'key, important, primary' => 'main',
      'leverage' => 'to use, build on',
      'make an application' => 'apply',
      'make a complaint' => 'complain',
      'methodology' => 'method',
      'notwithstanding' => 'even though, though',
      'obtain' => 'get, have',
      'prior to' => 'before',
      'primary' => 'main',
      'programme' => 'program',
      'provide' => 'give',
      'provide a response to' => 'respond to',
      'provide assistance with' => 'help',
      'pursuant to' => 'under',
      'reach a decision' => 'decide',
      'require' => 'need or must',
      'reuse, re-using' => 're-use, reusing',
      'subsequently' => 'after',
      'that is the reason why' => 'that is why, the reason why',
      'the way in which' => 'how',
      'the reason is because' => 'because, the reason is',
      'thereafter' => 'then, afterwards',
      'until such time as' => 'until',
      'upon' => 'on',
      'user centred design' => 'user-centred design',
      'utilise' => 'use',
      'whether or not' => 'whether',
      'with reference to, with regard to, with respect to' => 'about, regarding'
    }.inject({}) do |agg, (k, v)|
      if Regexp.new("(?<![a-zA-Z])#{k}(?![a-zA-Z])").match(@content) != nil
        agg[k] = v
      end
      agg
    end

  end
end