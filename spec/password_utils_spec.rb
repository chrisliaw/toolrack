
require 'toolrack'

include ToolRack::PassUtils

RSpec.describe ToolRack::PassUtils do

  it 'tester' do

    expect(all_lowercase_alpha?('asdf')).to be true
    expect(all_lowercase_alpha?('ASDF')).to be false
    expect(all_lowercase_alpha?('asdfF')).to be false
    expect(all_lowercase_alpha?('1234')).to be false
    expect(all_lowercase_alpha?(1234)).to be false
    
    expect(has_lowercase_alpha?('asdf')).to be true
    expect(has_lowercase_alpha?('asdfF')).to be true
    expect(has_lowercase_alpha?('1234')).to be false
    expect(has_lowercase_alpha?(1234)).to be false

    expect(all_uppercase_alpha?('ASDF')).to be true
    expect(all_uppercase_alpha?('ASDFd')).to be false
    expect(all_uppercase_alpha?('1234')).to be false
    expect(all_uppercase_alpha?(1234)).to be false
    
    expect(has_uppercase_alpha?('ASDF')).to be true
    expect(has_uppercase_alpha?('ASDFd')).to be true
    expect(has_uppercase_alpha?('1234')).to be false
    expect(has_uppercase_alpha?(1234)).to be false


    res, dres = all_alpha?('asdfASDF')
    expect(res).to be true
    res, dres = all_alpha?('asdfASDF1234')
    expect(res).to be false
    expect(dres[:has_num]).to be true
    res, dres = all_alpha?('asdfASDF^$#%')
    expect(res).to be false
    expect(dres[:has_symbol]).to be true
    res, dres = all_alpha?('1234')
    expect(res).to be false
    expect(dres[:has_lower_alpha]).to be false
    expect(dres[:has_upper_alpha]).to be false
    res, dres = all_alpha?(1234)
    expect(res).to be false

    res, dres = has_alpha?('asdfASDF')
    expect(res).to be true
    res, dres = has_alpha?('asdfASDF1234')
    expect(res).to be true
    res, dres = has_alpha?('asdfASDF^$#%')
    expect(res).to be true
    res, dres = has_alpha?('1234')
    expect(res).to be false
    res, dres = has_alpha?(1234)
    expect(res).to be false

    expect(all_number?(1234)).to be true
    expect(all_number?('1234')).to be true
    expect(all_number?('1234asdc*%')).to be false
    expect(all_number?('asdaf')).to be false

    expect(has_number?(1234)).to be true
    expect(has_number?('1234')).to be true
    expect(has_number?('1234asdc*%')).to  be true
    expect(has_number?('asdaf')).to be false

    res, dres = all_alpha_numeric?('asdf')
    p dres if res
    expect(res).to be false
    res, dres = all_alpha_numeric?('asdfASDF')
    p dres if res
    expect(res).to be false
    res, dres = all_alpha_numeric?('a2s34d5f5A2SDF')
    p dres if not res
    expect(res).to be true
    res, dres = all_alpha_numeric?('1s23d%#asdfSDF')
    p dres if res
    expect(res).to be false

    res = has_alpha_numeric?('asdf')
    expect(res).to be true
    res = has_alpha_numeric?('asdfASDF')
    expect(res).to be true
    res = has_alpha_numeric?('a2s34d5f5A2SDF')
    expect(res).to be true
    expect(has_alpha_numeric?('1s23d%#asdf')).to be true
    expect(has_alpha_numeric?('%#*\\&')).to be false


    res, dres = all_alpha_numeric_and_symbol?('asdf')
    p dres if res
    expect(res).to be false
    res, dres = all_alpha_numeric_and_symbol?('asdfASDF')
    p dres if res
    expect(res).to be false
    res, dres = all_alpha_numeric_and_symbol?('asdf123SADF')
    p dres if res
    expect(res).to be false
    res, dres = all_alpha_numeric_and_symbol?('asdf123SADF%$Y^')
    p dres if not res
    expect(res).to be true

    res, dres = has_alpha_numeric_or_symbol?('asdf')
    p dres if not res
    expect(res).to be true
    res, dres = has_alpha_numeric_or_symbol?('asdfASDF')
    p dres if not res
    expect(res).to be true
    res, dres = has_alpha_numeric_or_symbol?('asdf123SADF')
    p dres if not res
    expect(res).to be true
    res, dres = has_alpha_numeric_or_symbol?('asdf123SADF%$Y^')
    p dres if not res
    expect(res).to be true


  end

  it 'generates random password' do
    out = gen_rand_pass 
    expect(out).not_to be_nil
    expect(out.length == 12).to be true
    res, dres = all_alpha_numeric_and_symbol?(out)
    if not res
      p out
      p dres
    end
    expect(res).to be true

    out = gen_rand_pass(24)
    expect(out).not_to be_nil
    expect(out.length == 24).to be true

    out = gen_rand_pass(12, { complexity: 0 })
    expect(out).not_to be_nil
    expect(out.length == 12).to be true
    expect(all_lowercase_alpha?(out)).to be true

    out = gen_rand_pass(1024,{ complexity: 0} )
    expect(out).not_to be_nil
    expect(out.length == 1024).to be true
    expect(all_lowercase_alpha?(out)).to be true


    out = gen_rand_pass(12, { complexity: 1 })
    expect(out).not_to be_nil
    expect(out.length == 12).to be true
    expect(all_lowercase_alpha?(out)).to be true

    out = gen_rand_pass(24, { complexity: 2 })
    expect(out).not_to be_nil
    expect(out.length == 24).to be true
    res, dres = all_alpha?(out)
    if not res
      p out
      p dres
    end

    out = gen_rand_pass(24, { complexity: 3 })
    expect(out).not_to be_nil
    expect(out.length == 24).to be true
    res, dres = all_alpha_numeric?(out)
    if not res
      p out
      p dres
    end

    out = gen_rand_pass(12, { complexity: 4 })
    expect(out).not_to be_nil
    expect(out.length == 12).to be true
    res, dres = all_alpha_numeric_and_symbol?(out)
    if not res
      p out
      p dres
    end

    out = gen_rand_pass(2048, { complexity: 4 })
    expect(out).not_to be_nil
    expect(out.length == 2048).to be true
    res, dres = all_alpha_numeric_and_symbol?(out)
    if not res
      p out
      p dres
    end

    out = gen_rand_pass(24, { complexity: 5 })
    expect(out).not_to be_nil
    expect(out.length == 24).to be true
    res, dres = all_alpha_numeric_and_symbol?(out)
    if not res
      p out
      p dres
    end

    out = gen_rand_pass(nil)
    expect(out).not_to be_nil
    expect(out.length == 12).to be true
    res, dres = all_alpha_numeric_and_symbol?(out)
    if not res
      p out
      p dres
    end

    expect { gen_rand_pass(3, { complexity: 5 }) }.to raise_exception(Antrapol::ToolRack::PasswordUtils::PasswordUtilsError)

  end

end
